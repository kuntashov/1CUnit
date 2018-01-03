﻿
#Область Инициализация
	
&НаКлиенте
Перем КонтекстЯдра;

&НаКлиенте
Перем Ожидаем;

&НаКлиенте
Перем ТестКлиент;

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	ПолноеИмяБраузераТестов = КонтекстЯдра.Объект.ПолноеИмяБраузераТестов;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	ТестКлиент = КонтекстЯдра.Плагин("ТестКлиент");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗапускомТеста() Экспорт
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаТеста() Экспорт
КонецПроцедуры

#КонецОбласти  

#Область ВспомогательныеМетоды
	
&НаСервере
// Добавляет значение с ключом в тестовые данные для УФ 
Процедура ДобавитьТестовыеДанные(Ключ, ТестовыеДанные)
	
	СтрокаТестовыхДанных= ТестовыеДанныеУФ.НайтиСтроки(Новый Структура("Ключ", Ключ));
	
	Если СтрокаТестовыхДанных.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТестовыйДокумент= ТестовыеДанныеУФ.Добавить();
	
	СтрокаТестовыйДокумент.Ключ= Ключ;
	
	Значение= Новый СписокЗначений;
	Значение.Добавить(ТестовыеДанные, Ключ);
	
	СтрокаТестовыйДокумент.Значение= Значение;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
// Возвращает первое значение из списка по ключу из тестовых данные для УФ 
Функция ПолучитьТестовыеДанные(ТестовыеДанныеУФ, Ключ)
	
	СписокТестовыхДанных= ПолучитьСписокТестовыхДанных(ТестовыеДанныеУФ, Ключ);
	
	Если СписокТестовыхДанных = Неопределено Тогда
		ТестовыеДанные= Неопределено;
	Иначе
		ТестовыеДанные= СписокТестовыхДанных[0].Значение;
	КонецЕсли;
	
	Возврат ТестовыеДанные;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Возвращает список значение по ключу из тестовых данные для УФ 
Функция ПолучитьСписокТестовыхДанных(ТестовыеДанныеУФ, Ключ)
	
	СтрокиТестовыхДанных= ТестовыеДанныеУФ.НайтиСтроки(Новый Структура("Ключ", Ключ));
	
	Если Не СтрокиТестовыхДанных.Количество() Тогда
		СписокТестовыхДанных= Неопределено;
	Иначе
		СписокТестовыхДанных= СтрокиТестовыхДанных[0].Значение;
	КонецЕсли;
	
	Возврат СписокТестовыхДанных;
	
КонецФункции

// { Подсистема конфигурации xUnitFor1C

&НаСервере
Функция ПолучитьКонтекстЯдраНаСервере()
	
	// Получаем доступ к серверному контексту обработки с использованием 
	// полного имени метаданных браузера тестов. Иначе нет возможности получить
	// доступ к серверному контексту ядра, т.к. изначально вызов был выполнен на клиенте.
	// При передаче на сервер клиентский контекст теряется.
	КонтекстЯдра = Неопределено;
	МетаданныеЯдра = Метаданные.НайтиПоПолномуИмени(ПолноеИмяБраузераТестов);
	Если НЕ МетаданныеЯдра = Неопределено
		И Метаданные.Обработки.Содержит(МетаданныеЯдра) Тогда
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ПолноеИмяБраузераТестов, "Обработка", "Обработки");
		Выполнить("КонтекстЯдра = " + ИмяОбработкиКонекстаЯдра + ".Создать()");	
	Иначе
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ПолноеИмяБраузераТестов, "ВнешняяОбработка", "ВнешниеОбработки");
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ИмяОбработкиКонекстаЯдра, ".", Символы.ПС);
		МенеджерОбъектов = СтрПолучитьСтроку(ИмяОбработкиКонекстаЯдра, 1);
		ИмяОбъекта = СтрПолучитьСтроку(ИмяОбработкиКонекстаЯдра, 2);
		Выполнить("КонтекстЯдра = " + МенеджерОбъектов + ".Создать("""+ИмяОбъекта+""")");	
	КонецЕсли;
	
	Возврат КонтекстЯдра;
	
КонецФункции

// } Подсистема конфигурации xUnitFor1C

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдра) Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Если СисИнфо.ВерсияПриложения < "8.3.0.0" Тогда
		Возврат;
	КонецЕсли;
	
	НаборТестов.НачатьГруппу("Проверка интерфейса автоматического тестирования", Истина);
	
	НаборТестов.Добавить("Тест_ПодключениеКлиента", , "Подключение клиента тестирования");
	
	НаборТестов.Добавить("Тест_ОткрытиеИПроведение", , "Открытие и проведение документа");
	НаборТестов.Добавить("Тест_ПроверкаДвижений", , "Проверка движений");
	
	НаборТестов.Добавить("Тест_УстаовкаОтбораВСпискеПоРегистратору", , "Установка отбора в списке по регистратору");
	
	НаборТестов.ДобавитьДеструктор("Тест_ОтключениеКлиента", "Оключение клиента тестирования и удаление тестовых данных");
	
КонецПроцедуры

&НаКлиенте
Процедура Тест_ПодключениеКлиента() Экспорт
	
	ТестКлиент.ПодключениеКлиентаТестирования("Администратор", "");
	
КонецПроцедуры

&НаКлиенте
Процедура Тест_ОткрытиеИПроведение() Экспорт

	ТестовыеДанные= ПолучитьТестовыйДокумент();
	
	Ожидаем.Что(ТестовыеДанные, "Тестовые данные").Не_().ЭтоНеопределено();

	ТестКлиент
		.ОткрытиеФормыСписка(ТестовыеДанные.ПолноеИмя, ТестовыеДанные.Имя)
		.ПоискВСписке(Новый Структура("Номер,Дата", ТестовыеДанные.Номер, Строка(ТестовыеДанные.Дата)))
		.ОткрытиеВСписке(ТестовыеДанные.Представление)
		.Проведение()
	;
	
КонецПроцедуры

&НаКлиенте
Процедура Тест_ПроверкаДвижений() Экспорт
	
	ТестовыеДанные= ПолучитьТестовыйДокумент();
	
	Ожидаем.Что(ТестовыеДанные, "Тестовые данные").Не_().ЭтоНеопределено();
	

	ТестКлиент
		.ОткрытиеФормыСписка("РегистрСведений.РСПодчиненныйРегистратору", "РСПодчиненный регистратору")
		.УстановкаОтбораВСписке(Новый Структура("Ключ,Значение,ПредставлениеТипаДанных,ЗаголовокОкнаВыбораДанных", "Регистратор", СтрШаблон("Номер=%1;Дата=%2", ТестовыеДанные.Номер, ТестовыеДанные.Дата), "Документ2", "Документ2"))
		.КоличествоСтрокВСписке("Движения документа " + ТестовыеДанные.Представление);
	;
	
	Ожидаем.ЧтоПроверяемоеЗначение(ТестКлиент).Равно(ТестовыеДанные.КоличествоСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура Тест_УстаовкаОтбораВСпискеПоРегистратору() Экспорт
	
	// перезаполняем время так как оно изменено при оперативном проведении во время предыдущих тестов
	ТестовыеДанные= ПолучитьТестовыйДокумент();
	
	Ожидаем.Что(ТестовыеДанные, "Тестовые данные").Не_().ЭтоНеопределено();

	ТестКлиент
		.ОткрытиеФормыСписка("РегистрСведений.РСПодчиненныйРегистратору", "РСПодчиненный регистратору")
		.УстановкаОтбораВСпискеПоРегистратору(ТестовыеДанные.ЗаголовокСписка, ТестовыеДанные.ПредставлениеТипа, СтрШаблон("Номер=%1;Дата=%2", ТестовыеДанные.Номер, ТестовыеДанные.Дата))
		.КоличествоСтрокВСписке("Движения документа " + ТестовыеДанные.Представление);
	;
	
	Ожидаем.ЧтоПроверяемоеЗначение(ТестКлиент).Равно(ТестовыеДанные.КоличествоСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура Тест_ОтключениеКлиента() Экспорт

	//УдалитьТестовыйДокумент();
	
	ТестКлиент.ОтключениеКлиентаТестирования();
	
КонецПроцедуры

#КонецОбласти 

#Область ГенерацияТестовыхДанных
	
&НаСервере
Функция СоздатьТестовыйДокументНаСервере(СтарыйТестовыйДокумент)
	
	Если СтарыйТестовыйДокумент = Неопределено Тогда
		
		ТестовыйДокумент= Документы.Документ2.СоздатьДокумент();
		
		ТестовыйДокумент.Дата= ТекущаяДата();
		ТестовыйДокумент.УстановитьНовыйНомер();
		ТестовыйДокумент.Состав.Добавить();
		ТестовыйДокумент.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
		
	Иначе
		ТестовыйДокумент= СтарыйТестовыйДокумент.Ссылка.ПолучитьОбъект();
	КонецЕсли;
	
	
	МетаданныеДокумента= ТестовыйДокумент.Метаданные();
	
	ТестовыеДанные= Новый Структура;
	ТестовыеДанные.Вставить("Ссылка", ТестовыйДокумент.Ссылка);
	ТестовыеДанные.Вставить("Номер", ТестовыйДокумент.Номер);
	ТестовыеДанные.Вставить("Дата", ТестовыйДокумент.Дата);
	ТестовыеДанные.Вставить("Имя", МетаданныеДокумента.Имя);
	ТестовыеДанные.Вставить("ПолноеИмя", МетаданныеДокумента.ПолноеИмя());
	ТестовыеДанные.Вставить("Представление", Строка(ТестовыйДокумент));
	ТестовыеДанные.Вставить("КоличествоСтрок", ТестовыйДокумент.Состав.Количество());
	//TODO: корректные описания из метаданных
	ТестовыеДанные.Вставить("ПредставлениеТипа", МетаданныеДокумента.Имя);
	ТестовыеДанные.Вставить("ЗаголовокСписка", МетаданныеДокумента.Имя);
	
	Возврат ТестовыеДанные;
	
КонецФункции

&НаКлиенте
Функция ПолучитьТестовыйДокумент()
	// Тестовый документ создаём только один раз. В следующий раз только перезаполняем его данные.
	ТестовыйДокумент= КонтекстЯдра.ПолучитьКонтекст();
	КонтекстЯдра.СохранитьКонтекст(СоздатьТестовыйДокументНаСервере(ТестовыйДокумент));
	Возврат КонтекстЯдра.ПолучитьКонтекст();
КонецФункции

&НаКлиенте
Процедура УдалитьТестовыйДокумент()
	УдалитьТестовыйДокументНаСервере(КонтекстЯдра.ПолучитьКонтекст());
КонецПроцедуры

&НаСервере
Процедура УдалитьТестовыйДокументНаСервере(ТестовыеДанные)
	Если ТестовыеДанные <> Неопределено Тогда
		ТестовыеДанные.Ссылка.ПолучитьОбъект().Удалить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 



































