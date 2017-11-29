﻿&НаКлиенте
Перем ПолеЗначение;

&НаКлиенте
Перем ОкноПриложенияНастройкаСпискаФормаНастройкаСписка;

&НаКлиенте
Процедура Отладка(Команда)
	НастройкаСписка(Подключение());
КонецПроцедуры

&НаКлиенте
Функция Подключение()

	ТестовоеПриложение = Новый ТестируемоеПриложение(, Порт);
	ВремяОкончанияОжидания = ТекущаяДата() + 10;
	Подключен = Ложь;
	ОписаниеОшибкиСоединения = "";
	Пока Не ТекущаяДата() >= ВремяОкончанияОжидания Цикл
		Попытка
			ТестовоеПриложение.УстановитьСоединение();
			Подключен = Истина;
			Прервать;
		Исключение
			ОписаниеОшибкиСоединения = ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;
	Если Не Подключен Тогда
		ТестовоеПриложение = Неопределено;
		ВызватьИсключение "Не смогли установить соединение! " + Символы.ПС + ОписаниеОшибкиСоединения;
	КонецЕсли;
	
	Возврат ТестовоеПриложение;
	
КонецФункции

&НаКлиенте
Процедура НастройкаСписка(ТестовоеПриложение)

	ЗаголовокСписка= "РСПодчиненный регистратору";
	
	ОкноПриложения= ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), ЗаголовокСписка, , 30);
	ФормаСписка = ОкноПриложения.НайтиОбъект(Тип("ТестируемаяФорма"), ЗаголовокСписка);
	
	ЗаголовокСпискаРегистратора= "Документ2";
	ПредставлениеТипаРегистратора= "Документ2";
	
	ОписаниеСтрокиРегистратора = Новый Соответствие();
	ОписаниеСтрокиРегистратора.Вставить("Дата", "28.11.2017 14:56:18");
	ОписаниеСтрокиРегистратора.Вставить("Номер", "2");
	
	УстановитьОтборПоРегистратору(ТестовоеПриложение, ФормаСписка, ЗаголовокСпискаРегистратора, ПредставлениеТипаРегистратора, ОписаниеСтрокиРегистратора);
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоРегистратору(ТестовоеПриложение, ФормаСписка, ЗаголовокСпискаРегистратора, ПредставлениеТипаРегистратора, ОписаниеСтрокиРегистратора)

	
	КнопкаНастроитьСписок = ФормаСписка.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Настроить список...");
	КнопкаНастроитьСписок.Нажать();
	
	
	ОкноПриложенияНастройкаСписка = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), "Настройка списка", , 30);
	ОкноПриложенияНастройкаСпискаФормаНастройкаСписка = ОкноПриложенияНастройкаСписка.НайтиОбъект(Тип("ТестируемаяФорма"), "Настройка списка");
	
	ТаблицаВыбраныеПоля= ОкноПриложенияНастройкаСпискаФормаНастройкаСписка.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "Отбор. Элементы");
	
	ТаблицаВыбраныеПоля.Активизировать();
	
	ТаблицаВыбраныеПоля.ПерейтиКПоследнейСтроке();
	
	ТаблицаВыбраныеПоля.ВыделитьВсеСтроки();
	КоличествоСтрок= ТаблицаВыбраныеПоля.ПолучитьВыделенныеСтроки().Количество();
	
	Пока КоличествоСтрок > 1 Цикл
		
		ТаблицаВыбраныеПоля.ПерейтиКПоследнейСтроке();
		ТаблицаВыбраныеПоля.УдалитьСтроку();
		
		ТаблицаВыбраныеПоля.ВыделитьВсеСтроки();
		КоличествоСтрок= ТаблицаВыбраныеПоля.ПолучитьВыделенныеСтроки().Количество();
		
	КонецЦикла;
	
	ОписаниеСтроки = Новый Соответствие();                                                              
	ОписаниеСтроки.Вставить("Представление", "Регистратор");
	ЕстьРегистратор= ТаблицаВыбраныеПоля.ПерейтиКСтроке(ОписаниеСтроки, НаправлениеПереходаКСтроке.Вниз);
	
	// Добавляем в отбор регистратор когда его там нет
	
	Если Не ЕстьРегистратор Тогда
	
		ТаблицаДоступныеПоля = ОкноПриложенияНастройкаСпискаФормаНастройкаСписка.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "Доступные поля");
		
		ОписаниеСтроки = Новый Соответствие();                                                              
		ОписаниеСтроки.Вставить("Доступные поля", "Регистратор");
		
		ТаблицаДоступныеПоля.ПерейтиКСтроке(ОписаниеСтроки);

		ТаблицаДоступныеПоля.Выбрать();
		
	КонецЕсли;

	// Переходим к регистратору
	
	ТаблицаОтборЭлементы = ОкноПриложенияНастройкаСпискаФормаНастройкаСписка.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "Отбор. Элементы");

	ТаблицаОтборЭлементы.Активизировать();

	ОписаниеСтроки = Новый Соответствие();
	ОписаниеСтроки.Вставить("Представление", "Регистратор");
	ТаблицаОтборЭлементы.ПерейтиКСтроке(ОписаниеСтроки);
	
	// Устанавливаем использование когда оно не установлено
	
	ПолеИспользование = ОкноПриложенияНастройкаСпискаФормаНастройкаСписка.НайтиОбъект(Тип("ТестируемоеПолеФормы"), "Использование");
	Если ПолеИспользование.ПолучитьПредставлениеДанных() <> "Да" Тогда
		ПолеИспользование.УстановитьОтметку();
	КонецЕсли;
	
	ПолеЗначение = ОкноПриложенияНастройкаСпискаФормаНастройкаСписка.НайтиОбъект(Тип("ТестируемоеПолеФормы"), "Значение");
	ПолеЗначение.Активизировать();

	ТаблицаВыбраныеПоля.ИзменитьСтроку();

	ПолеЗначение.Выбрать();

	ОкноПриложенияВыборТипаДанных = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), "Выбор типа данных", , 30);
	ОкноПриложенияВыборТипаДанныхФормаВыборТипаДанных = ОкноПриложенияВыборТипаДанных.НайтиОбъект(Тип("ТестируемаяФорма"), "Выбор типа данных");
	
	ТаблицаТипов = ОкноПриложенияВыборТипаДанныхФормаВыборТипаДанных.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), , "TypeTree");

	ТаблицаТипов.Активизировать();

	ОписаниеСтроки = Новый Соответствие();
	ОписаниеСтроки.Вставить("", ПредставлениеТипаРегистратора);
	ТаблицаТипов.ПерейтиКСтроке(ОписаниеСтроки);
	
	ТаблицаТипов.Выбрать();
	
	ОкноПриложенияВыборРегистратора = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), ЗаголовокСпискаРегистратора, , 30);
	ОкноПриложенияРегистратораФормаВыборРегистратора = ОкноПриложенияВыборРегистратора.НайтиОбъект(Тип("ТестируемаяФорма"), ЗаголовокСпискаРегистратора);
	
	ТаблицаДокументов= ОкноПриложенияРегистратораФормаВыборРегистратора.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), , "Список");
	
	ТаблицаДокументов.ПерейтиКСтроке(ОписаниеСтрокиРегистратора);
	
	ТаблицаДокументов.Выбрать();
	
	ТаблицаВыбраныеПоля.ЗакончитьРедактированиеСтроки(Ложь);

	КнопкаЗавершитьРедактирование = ОкноПриложенияНастройкаСпискаФормаНастройкаСписка.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Завершить редактирование");
	КнопкаЗавершитьРедактирование.Нажать();
	
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьАлгоритм(Команда)
	Выполнить(ТекстАлгоритма);
КонецПроцедуры





