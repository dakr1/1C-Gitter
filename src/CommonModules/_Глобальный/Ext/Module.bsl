﻿
Процедура ЛогОтладка( Знач пТекст ) Экспорт
	
	Сообщить( "" + ТекущаяДата() + ". " + пТекст, СтатусСообщения.БезСтатуса );
	
КонецПроцедуры

Процедура ЛогИнформация( Знач пТекст ) Экспорт
	
	Сообщить( "" + ТекущаяДата() + ". " + пТекст, СтатусСообщения.Информация );
	
КонецПроцедуры

Процедура ЛогОшибка( Знач пТекст ) Экспорт
	
	Сообщить( "" + ТекущаяДата() + ". " + пТекст, СтатусСообщения.ОченьВажное );
	
КонецПроцедуры

Процедура ЛогКоманда( Знач пТекст ) Экспорт
	
	Сообщить( " > " + пТекст );
	
КонецПроцедуры

Процедура ЛогВыводКоманды( Знач пТекст ) Экспорт

	Сообщить( "		>> " + пТекст );

КонецПроцедуры

Процедура ЛогВыводКомандыИзФайла( имяФайлаВывода ) Экспорт
	
	Если Не ФайлСуществует( имяФайлаВывода ) Тогда
		
		Возврат;
	
	КонецЕсли;
	
	чтениеФайла = Новый ЧтениеТекста( имяФайлаВывода, КодировкаТекста.UTF8 );
	
	текСтрока = чтениеФайла.ПрочитатьСтроку();
	
	Пока текСтрока <> Неопределено Цикл
		
		ЛогВыводКоманды( текСтрока );
		
		текСтрока = чтениеФайла.ПрочитатьСтроку();
		
	КонецЦикла;
	
	чтениеФайла.Закрыть();
	
	УдалитьФайлы( имяФайлаВывода );
	
КонецПроцедуры


Функция ФайлСуществует( Знач пИмяФайла ) Экспорт
	
	Если Не ЗначениеЗаполнено( пИмяФайла ) Тогда
		
		Возврат Ложь;
	
	КонецЕсли;
	
	Файл = Новый Файл( пИмяФайла );
	
	Возврат Файл.Существует() И Файл.ЭтоФайл();
	
КонецФункции

Процедура ОбеспечитьТекстовыйФайл( Знач пИмяФайла ) Экспорт
	
	Если Не ЗначениеЗаполнено( пИмяФайла ) Тогда
		
		Возврат;
	
	КонецЕсли;
	
	Если Не ФайлСуществует( пИмяФайла ) Тогда
		
		записьФайла = Новый ЗаписьТекста( пИмяФайла );
		записьФайла.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбеспечитьКаталог( Знач Путь ) Экспорт
	
	Объект = Новый Файл( Путь );
	
	Если Не Объект.Существует() Тогда
		
		СоздатьКаталог( Путь );
		
	ИначеЕсли НЕ Объект.ЭтоКаталог() Тогда
		
		ВызватьИсключение "Не удается создать каталог " + Путь + ". По данному пути уже существует файл.";
		
	КонецЕсли;
	
КонецПроцедуры

Функция Экранировать( Значение ) Экспорт
	
	Возврат СтрЗаменить( Значение, """", """""" );
	
КонецФункции


#Если Не ВебКлиент Тогда

Функция ВыполнитьКоманду( Знач пРабочийКаталог,
						  Знач ТекстКоманды,
						  Знач пОжидатьЗавершения = Истина,
						  Знач пПропуститьВыводЛога = Ложь ) Экспорт
	
	СтрокаЗапуска = "cmd.exe /c """ + ТекстКоманды + """";
	
	Если Не пПропуститьВыводЛога Тогда
		
		ФайлРезультата = Новый Файл( ПолучитьИмяВременногоФайла( "txt" ) );
		СтрокаЗапуска  = СтрокаЗапуска + " > """ + ФайлРезультата.ПолноеИмя + """";
		СтрокаЗапуска  = СтрокаЗапуска + " 2>&1"; //stderr
		
	КонецЕсли;
	
	ИмяКомандногоФайла = ирОбщий.СоздатьСамоудаляющийсяКомандныйФайлЛкс( СтрокаЗапуска );
	
	второйПараметр = "";
	
	ирКэш.ВКОбщая().Run( ИмяКомандногоФайла, второйПараметр, пРабочийКаталог, пОжидатьЗавершения, Ложь );
	
	Если Не пПропуститьВыводЛога
		И пОжидатьЗавершения
		И ФайлРезультата.Существует() Тогда
		
		ЛогВыводКомандыИзФайла( ФайлРезультата.ПолноеИмя );
		
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции


Функция ВыполнитьКомандныйФайл( Знач пРабочийКаталог,
								Знач пИмяФайла,
								Знач пОжидатьЗавершения = Истина ) Экспорт
	
	КодВозврата = Неопределено;
	
	запускальщик = _ОбщегоНазначенияПовтИсп.Запускальщик();
	
	Если запускальщик = Неопределено Тогда
		
		ЗапуститьПриложение( пИмяФайла, пРабочийКаталог, пОжидатьЗавершения, КодВозврата );
		
	Иначе
		
		запускальщик.CurrentDirectory = пРабочийКаталог;
		
		КодВозврата = запускальщик.Run( пИмяФайла, 0, Истина );
		
	КонецЕсли;
	
	Возврат КодВозврата;
	
КонецФункции


#КонецЕсли




