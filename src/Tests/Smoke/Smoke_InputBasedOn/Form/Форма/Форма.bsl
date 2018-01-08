﻿//начало текста модуля
#Область Служебные_функции_и_процедуры_xUnit

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Ожидаем;
&НаКлиенте
Перем Утверждения;


#КонецОбласти

#Область Служебные_функции_и_процедуры_VanessaBehavior

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,ОписаниеШага,ТипШага,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенногоНомерОт(Парам01,Парам02,Парам03,Парам04)","ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенногоНомерОт","Когда Я открываю форму документа ""АвтоВзаимозачет"" заполненного на основании проведенного ""ПоступлениеАвтомобилей"" номер ""АИ00000002"" от ""12.03.2017""","Открытие формы на основании проведенного документа","UI.Формы");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенного(Парам01,Парам02)","ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенного","И     Я открываю форму документа ""АвтоВзаимозачет"" заполненного на основании проведенного ""ПоступлениеАвтомобилей""","Открытие формы на основании проведенного документа","UI.Формы");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенногоНомерОт(Парам01,Парам02,Парам03,Парам04)","ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенногоНомерОт","Когда Я открываю форму документа ""АвтоВзаимозачет"" заполненного на основании не проведенного ""ПоступлениеАвтомобилей"" номер ""АВ00000080"" от ""04.09.2016""","Открытие формы на основании не проведенного документа","UI.Формы");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенного(Парам01,Парам02)","ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенного","И     Я открываю форму документа ""АвтоВзаимозачет"" заполненного на основании не проведенного ""ПоступлениеАвтомобилей""","Открытие формы на основании не проведенного документа","UI.Формы");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции


#КонецОбласти

#Область Работа_со_сценариями_VanessaBehavior

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт
	
КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Работа_с_тестами_xUnit

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗапускомТеста() Экспорт


КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	НужноИсключениеЕслиНеНайденоДокументов = Ложь;

	ТолькоУправляемыеФормы = Истина;
	Объект.ВыводитьСообщенияВЖурналРегистрации = Истина;	

	СписокИсключений_ДокументыПроведенные   = ПолучитьСписокИсключений(Истина);
	СписокИсключений_ДокументыНеПроведенные = ПолучитьСписокИсключений(Ложь);
	
	ОписаниеТестов = Новый Массив;
	ГенерацияФичТестовНаСервере(ОписаниеТестов);
	
	ТекущаяГруппа = "";
	Для каждого Тест Из ОписаниеТестов Цикл
		Если ТекущаяГруппа <> Тест.ТипОснование Тогда
			ТекущаяГруппа = Тест.ТипОснование;
			НаборТестов.НачатьГруппу("Тип документа основания""" + Тест.ТипОснование + """", Ложь);
		КонецЕсли;
		
		Если Тест.Проведен Тогда
			Рез = СписокИсключений_ДокументыПроведенные.НайтиПоЗначению(""+Тест.ВводитсяНаОсновании.Имя+"/"+Тест.ТипОснование);
		Иначе 
			Рез = СписокИсключений_ДокументыНеПроведенные.НайтиПоЗначению(""+Тест.ВводитсяНаОсновании.Имя+"/"+Тест.ТипОснование);
		КонецЕсли;
		
		Если Рез <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПолноеИмяФормы = "Документ." + Тест.ВводитсяНаОсновании.Имя + ".ФормаОбъекта";
		
		НаборТестов.Добавить("ТестДолжен_ВыполнитьОткрытиеФормыДокументаНаОснованииДругогоДокумента", 
							  НаборТестов.ПараметрыТеста(ПолноеИмяФормы, Тест.Основание), 
							  "Создание документа """ + Тест.ВводитсяНаОсновании.Синоним + """ на основании " + 
							  ?(Тест.Проведен, "", "не ") + "проведенного """ +
							  Тест.Основание + """");	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ВыполнитьОткрытиеФормыДокументаНаОснованииДругогоДокумента(ПолноеИмяФормы, Основание) Экспорт
	ПараметрыФормы = Новый Структура("Основание", Основание);
	ТестироватьФорму(ПолноеИмяФормы, ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ГенерацияФич(Команда)

	ОписаниеТестов = Новый Массив;
	ГенерацияФичТестовНаСервере(ОписаниеТестов);
	СписокИсключений_ДокументыПроведенные   = ПолучитьСписокИсключений(Истина);
	СписокИсключений_ДокументыНеПроведенные = ПолучитьСписокИсключений(Ложь);
	ТекущаяГруппа = "";
	Текст = Новый ТекстовыйДокумент;
	МассивТекстов = Новый Массив;
	Для каждого Тест Из ОписаниеТестов Цикл
		Если ТекущаяГруппа <> Тест.ТипОснование Тогда
			Если ТекущаяГруппа <> "" Тогда
				СоответствиеФорм = Новый Соответствие;
				СоответствиеФорм.Вставить("Имя",   ТекущаяГруппа);
				СоответствиеФорм.Вставить("Текст", Текст);
				
				МассивТекстов.Добавить(СоответствиеФорм);
				//Текст.Показать(ТекущаяГруппа, "Ввод на основании - " + ТекущаяГруппа + ".feature");
				
			КонецЕсли;
			Текст = Новый ТекстовыйДокумент;
			ТекущаяГруппа = Тест.ТипОснование;
			
			Текст.ДобавитьСтроку("# language: ru");
			Текст.ДобавитьСтроку("");
			
			Текст.ДобавитьСтроку("@" + Тест.ТипОснование);
			Текст.ДобавитьСтроку("@tree");
			Текст.ДобавитьСтроку("@smoke");
			Текст.ДобавитьСтроку("");
			
			Текст.ДобавитьСтроку("Функционал: Тестирование открытия форм для подсистемы ");
			Текст.ДобавитьСтроку("	Как Разработчик
								|	Я Хочу чтобы проверялось открытие формы всех элементов этой подсистемы
								|	Чтобы я мог гарантировать работоспособность заполнения форм на основании");
			Текст.ДобавитьСтроку("");
			Текст.ДобавитьСтроку("Сценарий: Ввод на основании документа """ + Тест.ТипОснование + """");
			
			ШаблонСнипета = "		Когда Я открываю форму документа ""#ВводитсяНаОсновании"" заполненного на основании #Проведен ""#ДокументОснования""";
		КонецЕсли;		
		
		Если Тест.Проведен Тогда
			Рез = СписокИсключений_ДокументыПроведенные.НайтиПоЗначению(""+Тест.ВводитсяНаОсновании.Имя+"/"+Тест.ТипОснование);
		Иначе 
			Рез = СписокИсключений_ДокументыНеПроведенные.НайтиПоЗначению(""+Тест.ВводитсяНаОсновании.Имя+"/"+Тест.ТипОснование);
		КонецЕсли;
		
		Если Рез <> Неопределено Тогда
			Продолжить;
		КонецЕсли;		

		Снипет = СтрЗаменить(ШаблонСнипета, "#ВводитсяНаОсновании", Тест.ВводитсяНаОсновании.Имя);
		Снипет = СтрЗаменить(Снипет, "#ДокументОснования", Тест.ТипОснование);
		Снипет = СтрЗаменить(Снипет, "#Проведен",  ?(Тест.Проведен, "", "не ") + "проведенного");
		
		Если УказыватьДокументОснование Тогда
			Снипет = Снипет + " номер ""#НомерДокументаОснования"" от ""#ДатаДокументаОснования""";
			Снипет = СтрЗаменить(Снипет, "#НомерДокументаОснования", Тест.Номер);
			Снипет = СтрЗаменить(Снипет, "#ДатаДокументаОснования",  Формат(Тест.Дата, "ДФ=dd.MM.yyyy"));
		КонецЕсли;
		
		Текст.ДобавитьСтроку(Снипет);
		ШаблонСнипета = СтрЗаменить(ШаблонСнипета, "	Когда", "	И    ");
	КонецЦикла;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите каталог для feature файлов";
	ДополнительныеПарам =  Новый Структура("МассивТекстов", МассивТекстов);
	ОповещениеОбВыборе  = Новый ОписаниеОповещения("КаталогСохраненияФичЗавершение", ЭтотОбъект, ДополнительныеПарам);
	Диалог.Показать(ОповещениеОбВыборе);	
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогСохраненияФичЗавершение(ВыбранныеФайлы, ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено или ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Каталог = ВыбранныеФайлы.Получить(0);
	ОповещениеОбЗаписи = Новый ОписаниеОповещения("ЗаписьФайлаЗавершение", ЭтотОбъект, Неопределено);
	Для каждого Элемент Из ДопПараметры["МассивТекстов"] Цикл
		ТекстДок = Элемент["Текст"];
		ТекстДок.НачатьЗапись(ОповещениеОбЗаписи, Каталог + "/"+ Элемент["Имя"] + ".feature", КодировкаТекста.UTF8);
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписьФайлаЗавершение(Результат, ДопПараметры) Экспорт

КонецПроцедуры

&НаСервере
Функция ПолучитьСписокИсключений(Проведен)

	ОсновнойОбъект = Объект();
	Если Проведен Тогда
		СписокИсключений = ОсновнойОбъект.ПолучитьСписокИсключений_ДокументыПроведенные();
	Иначе
		СписокИсключений = ОсновнойОбъект.ПолучитьСписокИсключений_ДокументыНеПроведенные();	
	КонецЕсли;
	
	Возврат СписокИсключений;

КонецФункции 

&НаСервере
Функция Объект()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Процедура ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Проведен, НомерДокумента = Неопределено, ДатаДокумента = Неопределено)

	Если ДатаДокумента <> Неопределено Тогда
		ДатаДокумента = Сред(ДатаДокумента, 7, 4) + Сред(ДатаДокумента, 4, 2) + Сред(ДатаДокумента, 1, 2);
	КонецЕсли;
	
	Основание = ПолучитьСсылкуНаДокументОснование(ДокументОснование, Проведен, НомерДокумента, ДатаДокумента);
	
	Если Основание = Неопределено Тогда
		ВызватьИсключение "Для """ + ИмяДокумента + """ не найдено документа основания";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", Основание);
	ПолноеИмяФормы = "Документ." + ИмяДокумента + ".ФормаОбъекта";
	ТестироватьФорму(ПолноеИмяФормы, ПараметрыФормы);

КонецПроцедуры // ПроверитьОткрытиеФормыНаОсновании()

&НаСервере
Функция ПолучитьСсылкуНаДокументОснование(ДокументОснование, Проведен, НомерДокумента, ДатаДокумента)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	#Док.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.#Док КАК #Док
		|ГДЕ
		|	НЕ #Док.ПометкаУдаления
		|	И #Док.Проведен = &Проведен
		|	#ЕстьНомерДата
		|
		|УПОРЯДОЧИТЬ ПО
		|	#Док.Дата УБЫВ";
		
	Если НомерДокумента <> Неопределено И ДатаДокумента <> Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ЕстьНомерДата", "И #Док.Номер = &Номер И #Док.Дата  = &Дата"); 
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ЕстьНомерДата", "");
	КонецЕсли;
	Запрос.УстановитьПараметр("Проведен",  Проведен);
	Запрос.УстановитьПараметр("Номер",     НомерДокумента);
	Запрос.УстановитьПараметр("Дата",      ДатаДокумента);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Док", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Если РезультатЗапроса.Количество() = 0 Тогда
		Если НомерДокумента <> Неопределено И ДатаДокумента <> Неопределено Тогда
			Возврат ПолучитьСсылкуНаДокументОснование(ДокументОснование, Проведен, Неопределено, Неопределено);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Возврат РезультатЗапроса[0].Ссылка;
	КонецЕсли;

КонецФункции // ПолучитьСсылкуНаДокументОснование()

// заимствовона из плагина дымовых тестов xUnit
&НаКлиенте
Процедура ТестироватьФорму(ПолноеИмяФормы, ПараметрыФормы) Экспорт
	
	КлючВременнойФормы = "908насмь9ыв3245";
	//Если Модально Тогда
	//	ТестируемаяФорма = ОткрытьФормуМодально(ПолноеИмяФормы, ПараметрыФормы);
	//Иначе
		//ошибка ="";
		//Попытка
		
		// К сожалению здесь исключения не ловятся https://github.com/xDrivenDevelopment/xUnitFor1C/issues/154
		ТестируемаяФорма = ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы,, КлючВременнойФормы);
		
		//Исключение
		//	ошибка = ОписаниеОшибки();
		//	Предупреждение(" поймали исключение 20" + ошибка);
		//КонецПопытки;
	//КонецЕсли;
	Если ТестируемаяФорма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//ТестируемаяФорма.Открыть(); // К сожалению здесь исключения не ловятся http://partners.v8.1c.ru/forum/thread.jsp?id=1080350#1080350
	Если ТестируемаяФорма.Открыта() = Ложь Тогда 
		ВызватьИсключение "ТестируемаяФорма """ + ПолноеИмяФормы+""" не открылась, а должна была открыться"; 
	КонецЕсли;
		
	Если ТипЗнч(ТестируемаяФорма) = Тип("УправляемаяФорма") Тогда
		ТестируемаяФорма.ОбновитьОтображениеДанных();
	Иначе
			//Если ЭтоОбычнаяФорма(ТестируемаяФорма) Тогда
		ТестируемаяФорма.Обновить();
	КонецЕсли;
	
	ЗакрытьФорму(ТестируемаяФорма);
	ЗавершитьТранзакцию();

КонецПроцедуры

&НаСервере
Процедура ЗавершитьТранзакцию()

	Если ТранзакцияАктивна() Тогда
		ОтменитьТранзакцию();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(ТестируемаяФорма)
	//Если ТипЗнч(ТестируемаяФорма) <> Тип("Форма") и ТипЗнч(ТестируемаяФорма) <> Тип("УправляемаяФорма") Тогда
	Если ТипЗнч(ТестируемаяФорма) <> Тип("УправляемаяФорма") Тогда
		Возврат;
	КонецЕсли; 
	ТестируемаяФорма.Модифицированность = Ложь;
	Если ТестируемаяФорма.Открыта() Тогда
		ТестируемаяФорма.Модифицированность = Ложь;
		//Попытка
			ТестируемаяФорма.Закрыть();
		//Исключение
		//	Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		//	ЗакрытьФормуБезусловноСОтменойТранзакции(ТестируемаяФорма);
		//	//Если ТранзакцияАктивна() Тогда
		//	//	ОтменитьТранзакцию();
		//	//КонецЕсли;
		//	//	//ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке());
		//	//НачатьТранзакцию();
		//	//ТестируемаяФорма.УстановитьДействие("ПередЗакрытием", Неопределено);
		//	//ТестируемаяФорма.УстановитьДействие("ПриЗакрытии", Неопределено);
		//	//ТестируемаяФорма.Закрыть();
		//	ВызватьИсключение Ошибка; 			
		//КонецПопытки;
	Иначе
		Попытка
			ТестируемаяФорма.Закрыть();
		Исключение
		КонецПопытки;
	КонецЕсли;
	ТестируемаяФорма = "";

КонецПроцедуры

&НаСервере
Процедура ГенерацияФичТестовНаСервере(ОписаниеТестов)
	
	СписокМетаданных = ПолучитьСписокМетаданныхНаСервере();
	СписокДокументыОснования = ПолучитьСсылкиНаДокументыОснованияНаСервере(СписокМетаданных);
	
	Для каждого ТипМетаданного Из СписокМетаданных Цикл
		ТипДокумента = ТипМетаданного.Значение;
		
		ВводятсяНаОснованииДокумента = СписокВводятсяНаОснованииДокументаНаСервере(ТипДокумента.Имя);
		Если ВводятсяНаОснованииДокумента.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;		
		
		Отбор = Новый Структура;
		Отбор.Вставить("ТипДокумента", ТипДокумента.Имя);
		СписокОснований = СписокДокументыОснования.НайтиСтроки(Отбор);
		Если СписокОснований.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для каждого ВводитсяНаОсновании Из ВводятсяНаОснованииДокумента Цикл
			Для каждого Основание Из СписокОснований Цикл			
				СоответствиеФорм = Новый Структура;
				СоответствиеФорм.Вставить("ВводитсяНаОсновании", ВводитсяНаОсновании.Значение);
				СоответствиеФорм.Вставить("Проведен",  Основание.Проведен);
				СоответствиеФорм.Вставить("Основание", Основание.Ссылка);
				СоответствиеФорм.Вставить("Номер", Основание.Номер);
				СоответствиеФорм.Вставить("Дата", Основание.Дата);
				СоответствиеФорм.Вставить("ТипОснование", Основание.ТипДокумента);
				
				ОписаниеТестов.Добавить(СоответствиеФорм);				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокМетаданныхНаСервере()

	СписокМетаданных = Новый СписокЗначений;
	Для каждого ТипДок Из Метаданные.Документы Цикл
		СписокМетаданных.Добавить(ТипДок, ТипДок.Имя);
	КонецЦикла;
	СписокМетаданных.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
	Возврат СписокМетаданных;

КонецФункции

&НаСервере
Функция СписокВводятсяНаОснованииДокументаНаСервере(ТипДокумента)
	
	ЯвляетсяОснованием = Новый СписокЗначений;
	
	ДокументОснования = Метаданные.Документы[ТипДокумента];
	//Если ДокументОснования.ИспользоватьСтандартныеКоманды Тогда	// исключаем документы которые пользователь не может создать из интерфейса
		Для каждого ДокументКоллекции ИЗ Метаданные.Документы Цикл
			ВводитсяНаОсновании = ДокументКоллекции.ВводитсяНаОсновании;
			Для каждого Док ИЗ ВводитсяНаОсновании Цикл
				Если Док = ДокументОснования Тогда
					ЯвляетсяОснованием.Добавить(Новый Структура("Имя, Синоним", ДокументКоллекции.Имя, ДокументКоллекции.Синоним), ДокументКоллекции.Имя);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;	
	//КонецЕсли;
	
	ЯвляетсяОснованием.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
	Возврат ЯвляетсяОснованием;
	
КонецФункции

&НаСервере
Функция ПолучитьСсылкиНаДокументыОснованияНаСервере(СписокМетаданных)

	ШаблонЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	#Док.Ссылка КАК Ссылка,
		|	#Док.Номер КАК Номер,
		|	#Док.Дата КАК Дата,
		|	#Док.Проведен КАК Проведен,
		|	""#Док"" КАК ТипДокумента
		|ПОМЕСТИТЬ #Док_Проведенные
		|ИЗ
		|	Документ.#Док КАК #Док
		|ГДЕ
		|	#Док.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	#Док.Дата УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	#Док.Ссылка КАК Ссылка,
		|	#Док.Номер КАК Номер,
		|	#Док.Дата КАК Дата,
		|	#Док.Проведен КАК Проведен,
		|	""#Док"" КАК ТипДокумента		
		|ПОМЕСТИТЬ #Док_НеПроведенные
		|ИЗ
		|	Документ.#Док КАК #Док
		|ГДЕ
		|	НЕ #Док.ПометкаУдаления
		|	И НЕ #Док.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	#Док.Дата УБЫВ
		|;
		|ВЫБРАТЬ
		|	#Док_Проведенные.Ссылка КАК Ссылка,
		|	#Док_Проведенные.Номер КАК Номер,
		|	#Док_Проведенные.Дата КАК Дата,
		|	#Док_Проведенные.Проведен КАК Проведен,
		|	#Док_Проведенные.ТипДокумента КАК ТипДокумента
		|ИЗ
		|	#Док_Проведенные КАК #Док_Проведенные
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	#Док_НеПроведенные.Ссылка КАК Ссылка,
		|	#Док_НеПроведенные.Номер КАК Номер,
		|	#Док_НеПроведенные.Дата КАК Дата,
		|	#Док_НеПроведенные.Проведен КАК Проведен,
		|	#Док_НеПроведенные.ТипДокумента КАК ТипДокумента
		|ИЗ
		|	#Док_НеПроведенные КАК #Док_НеПроведенные
		|";
	
	// Ищем тестовые документы: проведенный и не проведенный
	ТаблицаДокументовОснований = Новый ТаблицаЗначений;
	ТаблицаДокументовОснований.Колонки.Добавить("Ссылка");
	ТаблицаДокументовОснований.Колонки.Добавить("Номер");
	ТаблицаДокументовОснований.Колонки.Добавить("Дата");
	ТаблицаДокументовОснований.Колонки.Добавить("Проведен");
	ТаблицаДокументовОснований.Колонки.Добавить("ТипДокумента");
	
	Для каждого ТипМетаданного Из СписокМетаданных Цикл
		Запрос = Новый Запрос;
		Запрос.Текст = ШаблонЗапроса;
		Если ТипМетаданного.Значение.ДлинаНомера = 0 Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Док.Номер", """""");
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Док", ТипМетаданного.Значение.Имя);
		
		Попытка
			Результат = Запрос.Выполнить().Выгрузить();
			Результат.Сортировать("ТипДокумента Возр");
			Если Результат.Количество() > 0 Тогда
				ЗагрузитьВТаблицуЗначений(Результат, ТаблицаДокументовОснований);
			КонецЕсли;
		Исключение
			Сообщить("Возникли проблеммы с поиском документов оснований для """ + ТипМетаданного.Значение.Имя + """");
		КонецПопытки;
	КонецЦикла;
	
	Возврат ТаблицаДокументовОснований;
	
КонецФункции // ПолучитьОснованиеНаСервере()

&НаСервере
Процедура ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, ТаблицаПриемник)

	//Сформируем массив совпадающих колонок.
	МассивСовпадающихКолонок = Новый Массив();
	Для каждого Колонка Из ТаблицаПриемник.Колонки Цикл
		Если ТаблицаИсточник.Колонки.Найти(Колонка.Имя) <> Неопределено Тогда
			МассивСовпадающихКолонок.Добавить(Колонка.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого СтрокаТаблицыИсточника Из ТаблицаИсточник Цикл
		СтрокаТаблицыПриемника = ТаблицаПриемник.Добавить();
		// Заполним значения в совпадающих колонках.
		Для каждого ЭлементМассива Из МассивСовпадающихКолонок Цикл
			СтрокаТаблицыПриемника[ЭлементМассива] = СтрокаТаблицыИсточника[ЭлементМассива];
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры // ЗагрузитьВТаблицуЗначений()

#Область Реализация_Шагов_VanessaBehavior
&НаКлиенте
//Когда открываю форму документа "АвтоВзаимозачет" заполненного на основании проведенного "ПоступлениеАвтомобилей" номер "АИ00000002" от "12.03.2017"
//@ОткрываюФормуДокументаЗаполненногоНаОснованииПроведенногоНомерОт(Парам01,Парам02,Парам03,Парам04)
Процедура ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенногоНомерОт(ИмяДокумента, ДокументОснование,НомерДокумента,ДатаДокумента) Экспорт
	ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Истина, НомерДокумента, ДатаДокумента);
КонецПроцедуры

&НаКлиенте
//И     открываю форму документа "АвтоВзаимозачет" заполненного на основании проведенного "ПоступлениеАвтомобилей"
//@ОткрываюФормуДокументаЗаполненногоНаОснованииПроведенного(Парам01,Парам02)
Процедура ЯОткрываюФормуДокументаЗаполненногоНаОснованииПроведенного(ИмяДокумента, ДокументОснование) Экспорт
	ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Истина, Неопределено, Неопределено);
КонецПроцедуры

&НаКлиенте
//Когда открываю форму документа "АвтоВзаимозачет" заполненного на основании не проведенного "ПоступлениеАвтомобилей" номер "АВ00000080" от "04.09.2016"
//@ОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенногоНомерОт(Парам01,Парам02,Парам03,Парам04)
Процедура ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенногоНомерОт(ИмяДокумента, ДокументОснование,НомерДокумента,ДатаДокумента) Экспорт
	ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Ложь, НомерДокумента, ДатаДокумента);
КонецПроцедуры

&НаКлиенте
//И     открываю форму документа "АвтоВзаимозачет" заполненного на основании не проведенного "ПоступлениеАвтомобилей"
//@ОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенного(Парам01,Парам02)
Процедура ЯОткрываюФормуДокументаЗаполненногоНаОснованииНеПроведенного(ИмяДокумента, ДокументОснование) Экспорт
	ПроверитьОткрытиеФормыНаОсновании(ИмяДокумента, ДокументОснование, Ложь, Неопределено, Неопределено);
КонецПроцедуры

#КонецОбласти