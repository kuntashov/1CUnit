﻿#Область Инициализация

&НаКлиенте
Перем ЗапущенныеТестКлиенты;

&НаКлиенте
Перем ТестируемоеОкно;

&НаКлиенте
Перем ТестируемыйЭлемент;

&НаКлиенте
Перем ОписаниеОшибки;

&НаКлиенте
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(ВозможныеТипыПлагинов);
КонецФункции

#КонецОбласти 

#Область Интерфейс

&НаКлиенте
Процедура ПодключитьТестКлиент_ПакетныйРежим(Параметры_xddTestClient) Экспорт
	
	Если Параметры_xddTestClient.Количество() > 0 И ТипЗнч(Параметры_xddTestClient[0]) <> Тип("ФиксированныйМассив") Тогда
		НовыйМассивПараметров = Новый Массив;
		НовыйМассивПараметров.Добавить(Параметры_xddTestClient);
		Параметры_xddTestClient = НовыйМассивПараметров;
	КонецЕсли;
	
	Для Каждого ОчередныеПараметры Из Параметры_xddTestClient Цикл
		Попытка
			ПользовательПарольПорт = СтрРазделить(ОчередныеПараметры[0], ":");
			Если ПользовательПарольПорт.Количество() = 3 Тогда
				ТестКлиент = ПодключитьТестКлиент(
				ПользовательПарольПорт[0],
				ПользовательПарольПорт[1],
				ПользовательПарольПорт[2]);
				ЗапомнитьДанныеТестКлиента(ТестКлиент, ПользовательПарольПорт[0], ПользовательПарольПорт[2]);
			Иначе
				ТестКлиент = ПодключитьТестКлиент();
				ЗапомнитьДанныеТестКлиента(ТестКлиент, "", "");
			КонецЕсли;
		Исключение
			Инфо = ИнформацияОбОшибке();
			ОписаниеОшибки = "Ошибка подключения тест-клиента в пакетном режиме
			|" + ПодробноеПредставлениеОшибки(Инфо);
			
			ЗафиксироватьОшибкуВЖурналеРегистрации("xUnitFor1C.ПодключитьТестКлиент", ОписаниеОшибки);
			Сообщить(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПодключитьТестКлиент(ИмяПользователя = "", Пароль = "", Порт = 1538) Экспорт
	
	Результат = Неопределено;
	
	Попытка
		Выполнить "Результат = Новый ТестируемоеПриложение(, XMLСтрока(Порт));";
	Исключение
	КонецПопытки;
	
	Если Результат = Неопределено Тогда
		ВызватьИсключение "Не удалось создать объект ТестируемоеПриложение.
		|Возможно, что 1С:Предприятие 8 не было запущено в режиме Менеджера тестирования (ключ командной строки /TESTMANAGER)
		|При запуске Предприятия через Конфигуратор можно включить этот режим в параметрах конфигуратора Сервис -> Параметры -> Запуск 1С:Предприятия -> Дополнительные -> Автоматизированное тестирование -> пункт ""Запускать как менеджер тестирования"".";
	КонецЕсли;
	
	// Попытка подключиться к уже запущенному приложению.
	Подключен = Ложь;
	Попытка
		Результат.УстановитьСоединение();
		Подключен = Истина;
	Исключение
	КонецПопытки;
	
	Если Подключен Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЗапуститьПриложение(СтрокаЗапускаТестКлиента(ИмяПользователя, Пароль, Порт));
	
	ВремяОкончанияОжидания = ТекущаяДата() + ТаймаутВСекундах();
	ОписаниеОшибкиСоединения = "";
	Пока Не ТекущаяДата() >= ВремяОкончанияОжидания Цикл
		Попытка
			Результат.УстановитьСоединение();
			Подключен = Истина;
			Прервать;
		Исключение
			ОписаниеОшибкиСоединения = ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;
	
	Если Не Подключен Тогда
		ВызватьИсключение СтрШаблон(
		"Не смогли установить соединение с тестовым приложением для пользователя %1!
		|%2",
		ИмяПользователя,
		ОписаниеОшибкиСоединения); 
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьВсеТестКлиенты() Экспорт
	
	Если Не ЗначениеЗаполнено(ЗапущенныеТестКлиенты) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекЗначение Из ЗапущенныеТестКлиенты Цикл
		Если ЭтоLinux() Тогда
			ЗапуститьПриложение("kill -9 `ps aux | grep -ie TESTCLIENT | grep -ie 1cv8c | awk '{print $2}'`");
		Иначе
			Scr = Новый COMОбъект("MSScriptControl.ScriptControl");
			Scr.Language = "vbscript";
			Scr.AddCode(ТекстСкриптаЗавершитьТестКлиент(ТекЗначение.Порт));
		КонецЕсли;
	КонецЦикла;
	
	ЗапущенныеТестКлиенты.Очистить();
	
КонецПроцедуры

&НаКлиенте
Функция ТестКлиентПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(ЗапущенныеТестКлиенты) Тогда
		Возврат ЗапущенныеТестКлиенты[0].ТестКлиент;
	КонецЕсли;
	
	Результат = ПодключитьТестКлиент();
	ЗапомнитьДанныеТестКлиента(Результат, "", "");
	
	ПолучитьОсновноеОкно();
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ТестКлиентПоПараметрам(ИмяПользователя = "", Пароль = "", Порт = 1538) Экспорт
	
	Результат = НайтиЗапущенныйКлиент(ИмяПользователя, Порт);
	Если Результат <> Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = ПодключитьТестКлиент(ИмяПользователя, Пароль, Порт);
	ЗапомнитьДанныеТестКлиента(Результат, ИмяПользователя, Порт);
	
	ПолучитьОсновноеОкно();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#Область ИнтерфейсАвтоматическогоТестирования

&НаКлиенте
Функция ПолучитьОписаниеОшибки() Экспорт
	Возврат ОписаниеОшибки;
КонецФункции

&НаКлиенте
Функция ПолучитьТестируемыйЭлемент() Экспорт
	Возврат ТестируемыйЭлемент;
КонецФункции

&НаКлиенте
Функция ПолучитьТестируемоеОкно() Экспорт
	Возврат ТестируемоеОкно;
КонецФункции

&НаКлиенте
Функция ПолучитьОкно(ТекстЗаголовка, ОжиданиеСуществования= Истина) Экспорт
	
	ТестКлиент= ТестКлиентПоУмолчанию();
	
	Если ОжиданиеСуществования Тогда
		ТестируемоеОкно= ТестКлиент.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), ТекстЗаголовка, , 20);
	Иначе
		// Несуществующее окно НайтиОбъект ищет очень долго и вызывает ошибку при последующих подключениях
		ТестируемоеОкно= Неопределено;
		тестируемыеОкна= ТестКлиент.НайтиОбъекты(Тип("ТестируемоеОкноКлиентскогоПриложения"), , , 20);
		Для Каждого ТeкущееОкно Из тестируемыеОкна Цикл
			Если Найти(ТeкущееОкно.Заголовок, ТекстЗаголовка) Тогда
				ТестируемоеОкно= ТeкущееОкно;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТестируемоеОкно;	
	
КонецФункции

&НаКлиенте
Функция ПолучитьОсновноеОкно() Экспорт
	
	ТестКлиент= ТестКлиентПоУмолчанию();
	
	ОкнаТестКлиента= ТестКлиент.НайтиОбъекты(Тип("ТестируемоеОкноКлиентскогоПриложения"), , , 20);
	
	ТестируемоеОкно= Неопределено;
	
	Для каждого ОкноТестКлиента Из ОкнаТестКлиента Цикл
		Если ОкноТестКлиента.Основное Тогда
			ТестируемоеОкно= ОкноТестКлиента;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТестируемоеОкно;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуСписка(ПолноеИмяОбъектаМетаданных, ТекстЗаголовка= Неопределено) Экспорт
	
	ОсновноеОкно= ПолучитьОсновноеОкно();
	
	ОсновноеОкно.ВыполнитьКоманду("e1cib/list/" + ПолноеИмяОбъектаМетаданных); 
	
	Если ТекстЗаголовка <> Неопределено Тогда
		ТестируемоеОкно= ПолучитьОкно(ТекстЗаголовка);
		Если ТестируемоеОкно = Неопределено Тогда
			ТестируемыйЭлемент= Неопределено;
		Иначе
			ТестируемыйЭлемент= ТестируемоеОкно.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "Список", , 20);
		КонецЕсли;
	Иначе
		ТестируемоеОкно= Неопределено;
		ТестируемыйЭлемент= Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Функция НайтиВСписке(СтруктураПоиска) Экспорт
	
	УбедитьсяЧтоЭтоСписок();
	
	Если ЭтоПустойСписок(ТестируемыйЭлемент) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТестируемыйЭлемент.ПерейтиКПервойСтроке();
	
	Возврат ТестируемыйЭлемент.ПерейтиКСтроке(КОписаниюСтроки(СтруктураПоиска));	
	
КонецФункции

&НаКлиенте 
Функция ОткрытьВСписке(ТекстЗаголовка, СтруктураПоиска= Неопределено) Экспорт
	
	УбедитьсяЧтоЭтоСписок();
	
	Если СтруктураПоиска <> Неопределено Тогда
		НайтиВСписке(КОписаниюСтроки(СтруктураПоиска));	
	КонецЕсли;
	
	ТестируемыйЭлемент.Выбрать();
	
	УстановитьТестируемоеОкно(ТекстЗаголовка);
	
	Возврат (ТестируемоеОкно <> Неопределено);
	
КонецФункции

&НаКлиенте 
Функция КоличествоСтрокВСписке(Знач ТестСписок= Неопределено) Экспорт
	
	Если ТестСписок = Неопределено Тогда
		ТестСписок= ТестируемыйЭлемент;
	КонецЕсли;
	
	УбедитьсяЧтоЭтоСписок(ТестСписок);
	
	ТестируемыйЭлемент.ВыделитьВсеСтроки();
	ВыделенныеСтроки= ТестируемыйЭлемент.ПолучитьВыделенныеСтроки();
	
	Возврат ВыделенныеСтроки.Количество();
	
КонецФункции

&НаКлиенте 
Функция Провести(ЗакрытьПослеПроведения= Ложь) Экспорт
	
	ОписаниеОшибки= "";
	
	Если ЗакрытьПослеПроведения Тогда
		ИмяКнопки= "ФормаПровестиИЗакрыть";
	Иначе
		ТекстЗаголовкаКнопки= "ФормаПровести";
	КонецЕсли;
	
	ЗаголовокПроводимогоОкна= ТестируемоеОкно.Заголовок;
	
	ТестируемаяФорма= ТестируемоеОкно.НайтиОбъект(Тип("ТестируемаяФорма"), , , 20);
	
	Кнопка= ТестируемаяФорма.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), , ИмяКнопки, 20);
	
	Если Кнопка <> Неопределено Тогда
		
		Кнопка.Нажать();
		
		ПроведениеВыполнено= Истина;
		
		ТестКлиент= ТестКлиентПоУмолчанию();
		
		ИнформацияОбОшибке= ТестКлиент.ПолучитьТекущуюИнформациюОбОшибке();
		
		Если ИнформацияОбОшибке <> Неопределено Тогда
			ОписаниеОшибки= 
			    НСтр("ru='Описание=';en='Description='") + ИнформацияОбОшибке.Описание + "'" + Символы.ПС +
			    НСтр("ru='ИмяМодуля=';en='ModuleName='") + ИнформацияОбОшибке.ИмяМодуля + "'" + Символы.ПС +
			    НСтр("ru='НомерСтроки=';en='LineNumber='") + ИнформацияОбОшибке.НомерСтроки + "'" + Символы.ПС +
			    НСтр("ru='ИсходнаяСтрока=';en='SourceLine='") + ИнформацияОбОшибке.ИсходнаяСтрока;
			
			ПроведениеВыполнено= Ложь;
		Иначе
			
			ОкноОшибки= ПолучитьОкно("1С:Предприятие", Ложь);
			
			Если ОкноОшибки <> Неопределено Тогда
				
				ПолеОписанияОшибки= ОкноОшибки.НайтиОбъект(Тип("ТестируемоеПолеФормы"), "Ошибка*", , 20);
				
				Если ПолеОписанияОшибки <> Неопределено Тогда
					ОписаниеОшибки= ПолеОписанияОшибки.ТекстЗаголовка;
					ПроведениеВыполнено= Ложь;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		ПроведениеВыполнено= Ложь;
		ОписаниеОшибки= "Кнопка не найдена.";
	КонецЕсли;
	
	Возврат ПроведениеВыполнено;
	
КонецФункции

&НаКлиенте
Функция УстановитьОтборВСписке(Знач СтруктураПоиска= "") Экспорт
	
	Если ЭтоПустойСписок(ТестируемыйЭлемент) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОписаниеСтроки= КОписаниюСтроки(СтруктураПоиска);
	
	Если ОписаниеСтроки.Количество() Тогда
		Если НайтиВСписке(ОписаниеСтроки) Тогда
			КнопкаНайтиПоТекущемуЗначению = ТестируемоеОкно.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Найти по текущему значению");
			Для Каждого Элемент Из ОписаниеСтроки Цикл
				ПолеОтбора = ТестируемыйЭлемент.НайтиОбъект(Тип("ТестируемоеПолеФормы"), , Элемент.Ключ);
				ПолеОтбора.Активизировать();
				КнопкаНайтиПоТекущемуЗначению.Нажать();
			КонецЦикла;
		КонецЕсли
	Иначе
		КнопкаНайтиПоТекущемуЗначению = ТестируемоеОкно.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Найти по текущему значению");
		КнопкаНайтиПоТекущемуЗначению.Нажать();
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

&НаКлиенте
Функция УстановитьОтборВСпискеПоРегистратору(ЗаголовокСпискаРегистратора, ПредставлениеТипаРегистратора, СтруктураПоискаРегистратора) Экспорт

	ОписаниеОшибки= "";
	
	ТестКлиент= ТестКлиентПоУмолчанию();
	
	КнопкаНастроитьСписок = НайтиКнопкуФормы(ТестируемоеОкно, "Настроить список*");
	
	Если КнопкаНастроитьСписок = Неопределено Тогда
		ОписаниеОшибки= "Не найдены настройки списка.";
		Возврат Ложь;
	КонецЕсли;
	
	КнопкаНастроитьСписок.Нажать();
	
	Если Не ПоявилосьОкно(ТестКлиент, "Настройка списка") Тогда
		ОписаниеОшибки= "Не открылось окно Настройка списка.";
		Возврат Ложь;
	КонецЕсли;
	
	НастройкаСписка= ПолучитьСтруктуруОкнаПриложения(ТестКлиент, "Настройка списка");
	
	ТаблицаДоступныеПоля = НайтиТаблицуФормы(НастройкаСписка.Форма, "Доступные поля");
		
	ТаблицаВыбраныеПоля= НайтиТаблицуФормы(НастройкаСписка.Форма, "Отбор. Элементы");
	
	ТаблицаВыбраныеПоля.Активизировать();
	
	// Удаляем все отборы
	
	Пока Не ЭтоПустойСписок(ТаблицаВыбраныеПоля, 1) Цикл
		ТаблицаВыбраныеПоля.ПерейтиКПоследнейСтроке();
		ТаблицаВыбраныеПоля.УдалитьСтроку();
	КонецЦикла;
	
	ЕстьОтборРегистратор= Ложь;
	
	//ТаблицаВыбраныеПоля.ПерейтиКПервойСтроке();
	//ЕстьОтборРегистратор= ТаблицаВыбраныеПоля.ПерейтиКСтроке(КОписаниюСтроки("Доступные поля=Регистратор"), НаправлениеПереходаКСтроке.Вниз);
	
	// Добавляем в отбор регистратор когда его там нет
	
	Если Не ЕстьОтборРегистратор Тогда
		ЕстьПолеРегистратор= ТаблицаДоступныеПоля.ПерейтиКСтроке(КОписаниюСтроки("Доступные поля=Регистратор"));
		Если Не ЕстьПолеРегистратор Тогда
			ОписаниеОшибки= "Не найдено поле отбора Регистратор.";
			КнопкаЗавершитьРедактирование = НайтиКнопкуФормы(НастройкаСписка.Форма, "Отмена");
			КнопкаЗавершитьРедактирование.Нажать();
			Возврат Ложь;
		Иначе
			ТаблицаДоступныеПоля.Выбрать();
		КонецЕсли;
	КонецЕсли;

	// Переходим к регистратору
	
	ТаблицаВыбраныеПоля.Активизировать();

	ТаблицаВыбраныеПоля.ПерейтиКСтроке(КОписаниюСтроки("Представление=Регистратор"));
	
	// Устанавливаем использование когда оно не установлено
	
	ПолеИспользование = НайтиПолеФормы(НастройкаСписка.Форма, "Использование");
	
	Если ПолеИспользование.ПолучитьПредставлениеДанных() <> "Да" Тогда
		ПолеИспользование.УстановитьОтметку();
	КонецЕсли;
	
	ПолеЗначение = НайтиПолеФормы(НастройкаСписка.Форма, "Значение");
	ПолеЗначение.Активизировать();

	ТаблицаВыбраныеПоля.ИзменитьСтроку();

	ПолеЗначение.Выбрать();
	
	ВыборТипаДанных = ПолучитьСтруктуруОкнаПриложения(ТестКлиент, "Выбор типа данных");
	
	ТаблицаТипов = НайтиТаблицуФормы(ВыборТипаДанных.Форма, , "TypeTree");

	ТаблицаТипов.Активизировать();

	ТипРегистратораНайден= ТаблицаТипов.ПерейтиКСтроке(КОписаниюСтроки("=" + ПредставлениеТипаРегистратора));
	Если Не ТипРегистратораНайден Тогда
		ОписаниеОшибки= СтрШаблон("Не найден регистратор с типом ""%1""", ПредставлениеТипаРегистратора);
		ВыборТипаДанных.Окно.Закрыть();
		НастройкаСписка.Окно.Закрыть();
		Возврат Ложь;
	КонецЕсли;
	
	ТаблицаТипов.Выбрать();
	
	ВыборРегистратора = ПолучитьСтруктуруОкнаПриложения(ТестКлиент, ЗаголовокСпискаРегистратора);
	
	Если ВыборРегистратора.Окно= Неопределено Тогда
		ОписаниеОшибки= СтрШаблон("Не найдена форма выбора регистратора с заголовком ""%1""", ЗаголовокСпискаРегистратора);
		ВыборТипаДанных.Окно.Закрыть();
		НастройкаСписка.Окно.Закрыть();
		Возврат Ложь;
	КонецЕсли;
	
	ТаблицаДокументов= НайтиТаблицуФормы(ВыборРегистратора.Форма, , "Список");
	
	Если ЭтоПустойСписок(ТаблицаДокументов) Тогда
		РегистраторНайден= Ложь;
	Иначе
		ТаблицаДокументов.ПерейтиКПервойСтроке();
		РегистраторНайден= ТаблицаДокументов.ПерейтиКСтроке(КОписаниюСтроки(СтруктураПоискаРегистратора));
	КонецЕсли;

	Если РегистраторНайден Тогда
		ТаблицаДокументов.Выбрать();
		ТаблицаВыбраныеПоля.ЗакончитьРедактированиеСтроки(Ложь);
	Иначе
		ОписаниеОшибки= "Не найден регистратор.";
		ВыборРегистратора.Окно.Закрыть();
		НастройкаСписка.Окно.Закрыть();
		Возврат Ложь;
	КонецЕсли;
	
	КнопкаЗавершитьРедактирование = НайтиКнопкуФормы(НастройкаСписка.Форма, "Завершить редактирование");
	КнопкаЗавершитьРедактирование.Нажать();
	
	Возврат РегистраторНайден;
	
КонецФункции

#КонецОбласти 

#Область ВспомогательныеПроцедуры

&НаКлиенте
Функция ПолучитьКоличествоСтрокВСписке(ТестСписок)
	//TODO: когда в списке больше тысячи строк выдаётся сообщение и выделение будет долгим.
	// Нужно найти цивилизованный способ получения количества строк в списке.
	ТестСписок.ВыделитьВсеСтроки();
	Возврат ТестСписок.ПолучитьВыделенныеСтроки().Количество();
КонецФункции

&НаКлиенте
Функция ЭтоПустойСписок(ТестСписок, КоличествоСлужебныхСтрок= 0)
	Попытка
		ТестСписок.ПерейтиКСтроке();
		Для х= 0 По КоличествоСлужебныхСтрок - 1 Цикл
			ТестСписок.ПерейтиКСледующейСтроке();
		КонецЦикла; 
		Возврат Ложь;		
	Исключение
		Возврат Истина;		
	КонецПопытки;
КонецФункции

&НаКлиенте
Процедура Пауза(ЧислоСекунд)
	WSS=Новый COMОбъект("WScript.Shell");
	WSS.Run(СтрШаблон("ping -n %1 -w 1000 127.0.0.1", XMLСтрока(ЧислоСекунд + 1)) , 0, Истина);	
КонецПроцедуры

&НаКлиенте
Функция ПоявилосьОкно(ТестПриложение, ТекстЗаголовка= Неопределено, Имя= Неопределено)
	Возврат ТестПриложение.ОжидатьОтображениеОбъекта(Тип("ТестируемоеОкноКлиентскогоПриложения"), ТекстЗаголовка, Имя, 20);
КонецФункции

&НаКлиенте
Функция НайтиОкноПриложения(ТестПриложение, ТекстЗаголовка= Неопределено, Имя= Неопределено)
	Возврат ТестПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), ТекстЗаголовка, Имя, 20);
КонецФункции

&НаКлиенте
Функция НайтиФормуОкнаПриложения(ТестПриложение, ТекстЗаголовка= Неопределено, Имя= Неопределено)
	ТестОкно= НайтиОкноПриложения(ТестПриложение, ТекстЗаголовка, Имя);
	Если ТестОкно = Неопределено Тогда
		Возврат ТестОкно;
	КонецЕсли;
	Возврат ТестОкно.НайтиОбъект(Тип("ТестируемаяФорма"), ТекстЗаголовка, Имя, 20);
КонецФункции

&НаКлиенте
Функция НайтиФормуОкна(ТестФорма, ТекстЗаголовка= Неопределено, Имя= Неопределено)
	Возврат ТестФорма.НайтиОбъект(Тип("ТестируемаяФорма"), ТекстЗаголовка, Имя, 20);
КонецФункции

&НаКлиенте
Функция ПолучитьСтруктуруОкнаПриложения(ТестПриложение, ТекстЗаголовка= Неопределено, Имя= Неопределено)
	СтруктураОкна= Новый Структура("Окно,Форма");
	СтруктураОкна.Окно= НайтиОкноПриложения(ТестПриложение, ТекстЗаголовка, Имя);
	Если СтруктураОкна.Окно = Неопределено Тогда
		ВызватьИсключение "Не найдено окно приложения с заголовком " + ТекстЗаголовка;
	КонецЕсли;
	СтруктураОкна.Форма= НайтиФормуОкна(СтруктураОкна.Окно, ТекстЗаголовка, Имя);
	Возврат СтруктураОкна;
КонецФункции

&НаКлиенте
Функция НайтиТаблицуФормы(ТестФорма, ТекстЗаголовка= Неопределено, Имя= Неопределено)
	Возврат ТестФорма.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), ТекстЗаголовка, Имя, 20);
КонецФункции

&НаКлиенте
Функция НайтиПолеФормы(ТестФорма, ТекстЗаголовка= Неопределено, Имя= Неопределено)
	Возврат ТестФорма.НайтиОбъект(Тип("ТестируемоеПолеФормы"), ТекстЗаголовка, Имя, 20);
КонецФункции

&НаКлиенте
Функция НайтиКнопкуФормы(ТестФорма, ТекстЗаголовка= Неопределено, Имя= Неопределено)
	Возврат ТестФорма.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), ТекстЗаголовка, Имя, 20);
КонецФункции

&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Функция СтрокаЗапускаТестКлиента(ИмяПользователя = "", Пароль = "", Порт = "")
	
	Если Не ЗначениеЗаполнено(ИмяПользователя) Тогда
		ИмяПользователя = ИмяТекущегоПользователя();
	КонецЕсли;
	
	СтрокаЗапуска1с = КаталогПрограммы() + "1cv8c";
	
	Если Не ЭтоLinux() Тогда
		СтрокаЗапуска1с = СтрШаблон("%1.exe", СтрокаЗапуска1с);;
	КонецЕсли;
	
	Результат = СтрШаблон(
	"%1 ENTERPRISE /IBConnectionString""%2"" /WA- /N""%3"" %4 /TESTCLIENT -TPort%5",
	СтрокаЗапуска1с,
	СтрЗаменить(СтрокаСоединенияИнформационнойБазы(), """", """"""),
	ИмяПользователя,
	?(ПустаяСтрока(Пароль), ""," /P""" + Пароль + """"),
	XMLСтрока(Порт));
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяТекущегоПользователя()
	
	Возврат ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
КонецФункции

&НаКлиенте
Функция ТаймаутВСекундах()
	
	Возврат 20;
	
КонецФункции

&НаКлиенте
Функция ТекстСкриптаЗавершитьТестКлиент(НомерПорта)
	
	Результат = 
	
		"Option Explicit
		|
		|Dim objWMIService, objProcess, colProcess
		|
		|Set objWMIService = GetObject(""winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2"") 
		|
		|Set colProcess = objWMIService.ExecQuery(""Select * from Win32_Process Where (CommandLine Like '%/TESTCLIENT%' And ExecutablePath Like '%1cv8c%')"")
		|
		|For Each objProcess in colProcess
		|	objProcess.Terminate()
		|Next";
	
	Если ЗначениеЗаполнено(НомерПорта) Тогда
		Результат= СтрЗаменить(Результат, "%/TESTCLIENT%", "%/TESTCLIENT -TPort" + XMLСтрока(НомерПорта) + "%");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПолноеИмяИсполняемогоФайла()
	
	Возврат СтрШаблон("%1%2%3",
	КаталогПрограммы(),
	"1cv8c",
	РасширениеИсполняемогоФайла());
	
КонецФункции

&НаКлиенте
Функция РасширениеИсполняемогоФайла()
	
	Если ЭтоLinux() Тогда
		Возврат "";
	Иначе
		Возврат ".exe";
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ЭтоLinux()
	
	СисИнфо = Новый СистемнаяИнформация;
	ВерсияПриложения = СисИнфо.ВерсияПриложения;
	
	Возврат СтрНайти(Строка(СисИнфо.ТипПлатформы), "Linux") > 0;
	
КонецФункции

&НаСервере
Процедура ЗафиксироватьОшибкуВЖурналеРегистрации(Знач ИдентификаторГенератораОтчета, Знач ОписаниеОшибки)
	ЗаписьЖурналаРегистрации(ИдентификаторГенератораОтчета, УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьДанныеТестКлиента(ТестКлиент, ИмяПользователя, Порт)
	
	ДанныеТестКлиента = Новый Структура;
	ДанныеТестКлиента.Вставить("ТестКлиент", ТестКлиент);
	ДанныеТестКлиента.Вставить("ИмяПользователя", ИмяПользователя);
	ДанныеТестКлиента.Вставить("Порт", Порт);
	
	Если ЗапущенныеТестКлиенты = Неопределено Тогда
		ЗапущенныеТестКлиенты = Новый Массив;
	КонецЕсли;
	
	ЗапущенныеТестКлиенты.Добавить(ДанныеТестКлиента);
	
КонецПроцедуры

&НаКлиенте
Функция НайтиЗапущенныйКлиент(ИмяПользователя, Порт)
	
	Если Не ЗначениеЗаполнено(ЗапущенныеТестКлиенты) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для Каждого ТекЗапущенныйКлиент Из ЗапущенныеТестКлиенты Цикл
		Если ТекЗапущенныйКлиент.ИмяПользователя = ИмяПользователя 
			И ТекЗапущенныйКлиент.Порт = Порт Тогда
			Возврат ТекЗапущенныйКлиент.ТестКлиент;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Функция ЗабытьЗапущенныйКлиент(ИмяПользователя, Порт)
	
	Если Не ЗначениеЗаполнено(ЗапущенныеТестКлиенты) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для х = -ЗапущенныеТестКлиенты.Количество() + 1 По 0 Цикл
		ТекЗапущенныйКлиент= ЗапущенныеТестКлиенты[-х];
		Если ТекЗапущенныйКлиент.ИмяПользователя = ИмяПользователя 
			И ТекЗапущенныйКлиент.Порт = Порт Тогда
			ЗапущенныеТестКлиенты.Удалить(ТекЗапущенныйКлиент);
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура УстановитьТестируемоеОкно(ТекстЗаголовка)
	Если ТекстЗаголовка = Неопределено Тогда
		ТестируемоеОкно= Неопределено;
	Иначе
		ТестируемоеОкно= ПолучитьОкно(ТекстЗаголовка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УбедитьсяЧтоЭтоСписок(Знач ТестСписок= Неопределено) Экспорт
	
	Если ТестСписок = Неопределено Тогда
		ТестСписок= ТестируемыйЭлемент;
	КонецЕсли;
	
	Если ТипЗнч(ТестСписок) <> Тип("ТестируемаяТаблицаФормы") Тогда
		ВызватьИсключение "Тестируемый элемент не являяется списком";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Формирует из параметра Соответствие для использования в тиовых методах поиска
// Поддерживаемые типы
// 		Структура
// 		Строка			"Имя=Значение;"
// 		Соответствие
// 		Неопределено
Функция КОписаниюСтроки(Параметр) 
	
	ТипПараметра= ТипЗнч(Параметр);
	
	ОписаниеСтроки= Неопределено;
	
	Если ТипПараметра = Тип("Неопределено") Тогда
		
		ОписаниеСтроки= Новый Соответствие();
		
	ИначеЕсли ТипПараметра = Тип("Соответствие") Тогда
		
		ОписаниеСтроки= Параметр;
		
	ИначеЕсли ТипПараметра = Тип("Структура") Тогда
		
		ОписаниеСтроки = Новый Соответствие();
		
		Для каждого Элемент Из Параметр Цикл
			ОписаниеСтроки.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла; 
		
	ИначеЕсли ТипПараметра = Тип("Строка") Тогда
		
		ОписаниеСтроки = Новый Соответствие();
		
		Пары= СтрРазделить(Параметр, ";", Истина);
		
		Для каждого Пара Из Пары Цикл
			
			ИмяЗначение= СтрРазделить(Пара, "=", Истина);
			
			Если ИмяЗначение.Количество() = 0 Тогда
				Продолжить;
			ИначеЕсли ИмяЗначение.Количество() = 1 Тогда
				Значение= "";
			Иначе
				Значение= ИмяЗначение[1];
			КонецЕсли;
			
			Попытка
				ОписаниеСтроки.Вставить(ИмяЗначение[0], Значение);	
			Исключение
			КонецПопытки;
			
		КонецЦикла; 
		
	Иначе
		
		ВызватьИсключение "Неподдерживаемый тип " + ТипПараметра;
		
	КонецЕсли;
	
	Возврат ОписаниеСтроки;
	
КонецФункции

#КонецОбласти 

#Область Отладка

&НаКлиенте
Функция СформироватьСтруктуруПоиска()
	
	СтруктураПоиска= Новый Структура;
	
	Для каждого Элемент Из Отладка_СтруктураПоиска Цикл
		СтруктураПоиска.Вставить(Элемент.Ключ, Элемент.Значение);		
	КонецЦикла; 
	
	Возврат СтруктураПоиска;
	
КонецФункции

&НаКлиенте
Процедура Отладка_Подключить(Команда)
	ТестКлиентПоПараметрам(Отладка_ИмяПользователя, Отладка_Пароль, 1538);
КонецПроцедуры

&НаКлиенте
Процедура Отладка_Отключить(Команда)
	ЗавершитьВсеТестКлиенты();
КонецПроцедуры

&НаКлиенте
Процедура Отладка_ОткрытьСписок(Команда)
	ОткрытьФормуСписка(Отладка_ПолноеИмя, Отладка_ТекстЗаголовка);
	Если ТестируемоеОкно = Неопределено Тогда
		ВызватьИсключение "Не найдено окно с заголовком " + Отладка_ПолноеИмя ;
	КонецЕсли;
	Если ТестируемыйЭлемент = Неопределено Тогда
		ВызватьИсключение "Форма не содержит список";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отладка_ОткрытьВСписке(Команда)
	
	СтруктураПоиска= СформироватьСтруктуруПоиска();
	
	ОткрытьВСписке(Отладка_ТекстЗаголовка, Отладка_СтруктураПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура Отладка_НайтиВСписке(Команда)
	
	НайтиВСписке(СформироватьСтруктуруПоиска());
	
КонецПроцедуры

&НаКлиенте
Процедура Отладка_ОткрытьВСпискеТекущий(Команда)
	ОткрытьВСписке(Отладка_ТекстЗаголовка);
КонецПроцедуры

&НаКлиенте
Процедура Отладка_Провести(Команда)
	Провести(Отладка_ЗакрытьПослеПроведения);
КонецПроцедуры

&НаКлиенте
Процедура Отладка_УстановитьОтборВСписке(Команда)
	
	УстановитьОтборВСписке(СформироватьСтруктуруПоиска());
	
КонецПроцедуры

&НаКлиенте
Процедура Отладка_ОтборВСпискеПоРегистратору(Команда)
	ОтборУстановлен= УстановитьОтборВСпискеПоРегистратору(Отладка_ЗаголовокСпискаРегистратора, Отладка_ПредставлениеТипаРегистратора, СформироватьСтруктуруПоиска());
	Если ОтборУстановлен Тогда
		Сообщить("Отбор установлен");
	Иначе
		Сообщить(ОписаниеОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отладка_Пауза(Команда)
	Сообщить(ТекущаяДата());
	Пауза(Отладка_ЧислоСекунд);
	Сообщить(ТекущаяДата());
КонецПроцедуры

&НаКлиенте
Процедура Отладка_ЭтоПустойСписок(Команда)
	Сообщить(ЭтоПустойСписок(ТестируемыйЭлемент));
КонецПроцедуры

&НаКлиенте
Процедура Отладка_Выполнить(Команда)
	Выполнить(Отладка_Алгоритм);
КонецПроцедуры

#КонецОбласти 























