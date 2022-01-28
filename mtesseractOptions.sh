#!/bin/bash
 E='echo -e';e='echo -en';trap "R;exit" 2
 ESC=$( $e "\e")
 TPUT(){ $e "\e[${1};${2}H" ;}
 CLEAR(){ $e "\ec";}
# 25 возможно это
 CIVIS(){ $e "\e[?25l";}
# это цвет текста списка перед курсором при значении 0 в переменной  UNMARK(){ $e "\e[0m";}
 MARK(){ $e "\e[45m";}
# 0 это цвет заднего фона списка
 UNMARK(){ $e "\e[0m";}
# ~~~~~~~~ Эти строки задают цвет фона ~~~~~~~~
 R(){ CLEAR ;stty sane;CLEAR;};
#R(){ CLEAR ;stty sane;$e "\ec\e[37;44m\e[J";};
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 HEAD(){ for (( a=2; a<=23; a++ ))
 do
 TPUT $a 1
        $E "\xE2\x94\x82                                                                      \xE2\x94\x82";
 done
 TPUT 3 4
        $E "\033[36mЕдиничные опции                       \033[90m SINGLE OPTIONS\033[0m";
 TPUT 12 3
        $E "\033[36mОбщие озции\033[0m";
 TPUT 21 3
        $E "$(tput setaf 2)  Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter$(tput sgr 0) ";
 MARK;TPUT 1 1
        $E "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+";UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
   FOOT(){ MARK;TPUT 24 1
        $E "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+";UNMARK;}
# это управляет кнопками ввер/хвниз
 i=0; CLEAR; CIVIS;NULL=/dev/null
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
#
  M0(){ TPUT 5 3; $e " Cправочное сообщение                   \033[32m-h --help                  \033[0m";}
  M1(){ TPUT 6 3; $e " Дополнительная помощь                  \033[32m   --help-extra            \033[0m";}
  M2(){ TPUT 7 3; $e " Pежимы сегментации                     \033[32m   --help-psm              \033[0m";}
  M3(){ TPUT 8 3; $e " Pежимы OCR Engine                      \033[32m   --help-oem              \033[0m";}
  M4(){ TPUT 9 3; $e " Версия                                 \033[32m-v --version               \033[0m";}
  M5(){ TPUT 10 3; $e " Список доступных языков                \033[32m   --list-langs            \033[0m";}
  M6(){ TPUT 11 3; $e " Параметры тессеракта                   \033[32m   --print-parameters      \033[0m";}
#
  M7(){ TPUT 13 3; $e " CONFIGVAR значение VALUE               \033[32m-c CONFIGVAR=VALUE         \033[0m";}
  M8(){ TPUT 14 3; $e " Pазрешение N в точках                  \033[32m   --dpi N                 \033[0m";}
  M9(){ TPUT 15 3; $e " Указать несколько языков               \033[32m-l LANG           -l SCRIPT\033[0m";}
 M10(){ TPUT 16 3; $e " Настройте tesseract                    \033[32m   --psm N                 \033[0m";}
 M11(){ TPUT 17 3; $e " Pежим OCR Engine                       \033[32m   --oem N                 \033[0m";}
 M12(){ TPUT 18 3; $e " Pасположение пути к tessdata           \033[32m   --tessdata-dir PATH     \033[0m";}
 M13(){ TPUT 19 3; $e " Pасположение пользовательских шаблонов \033[32m   --user-patterns FILE    \033[0m";}
 M14(){ TPUT 20 3; $e " Rасположение пользовательских слов     \033[32m   --user-words FILE       \033[0m";}
#
 M15(){ TPUT 22 3; $e " EXIT                                                              ";}
# далее идет переменная LM=16 позволяющая выстраивать список в вертикаль.
LM=15
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
# Функция возвращения в меню
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
  0) S=M0;SC;if [[ $cur == enter ]];then R;echo " Показать справочное сообщение.";ES;fi;;
  1) S=M1;SC;if [[ $cur == enter ]];then R;echo " Показать дополнительную помощь для опытных пользователей.";ES;fi;;
  2) S=M2;SC;if [[ $cur == enter ]];then R;echo " Показать режимы сегментации страницы.";ES;fi;;
  3) S=M3;SC;if [[ $cur == enter ]];then R;echo " Показать режимы OCR Engine.";ES;fi;;
  4) S=M4;SC;if [[ $cur == enter ]];then R;echo " Возвращает текущую версию исполняемого файла tesseract.";ES;fi;;
  5) S=M5;SC;if [[ $cur == enter ]];then R;echo " Список доступных языков для движка tesseract. Может использоваться с --tessdata-dir ПУТЬ.
";ES;fi;;
  6) S=M6;SC;if [[ $cur == enter ]];then R;echo " Распечатать параметры тессеракта.";ES;fi;;
  7) S=M7;SC;if [[ $cur == enter ]];then R;echo "
 Установите для параметра CONFIGVAR значение VALUE. Допускается несколько аргументов -c.
";ES;fi;;
  8) S=M8;SC;if [[ $cur == enter ]];then R;echo "
 Укажите разрешение N в точках на дюйм для входных изображений. Типичное значение N - 300. Без этого параметра разрешение считывается
 из метаданных включеныe в изображение. Если изображение не содержит этой информации, Tesseract пытается ее угадать.
#
 Извлечение текста:
  tesseract recital-63.png recital --dpi 150
  tesseract bold-italic.png bold --dpi 150
";ES;fi;;
  9) S=M9;SC;if [[ $cur == enter ]];then R;echo "
 Используемый язык или сценарий. Если ничего не указано, предполагается eng (английский). Tesseract использует трехсимвольные
 языковые коды ISO 639-2 (см. ЯЗЫКИ И СЦЕНАРИИ).
#
 чтобы позволить tesseract знать язык, на котором мы хотим работать:
 tesseract hen-wlad-fy-nhadau.png anthem -l cym --dpi 150
#
 Если ваш документ содержит два или более языков (например, словарь валлийский-английский), вы можете использовать знак плюс (+)
 сказать tesseract добавить другой язык, вот так:
 tesseract image.png textfile -l eng+cym+fra
";ES;fi;;
 10) S=M10;SC;if [[ $cur == enter ]];then R;echo "
 Настройте, чтобы tesseract запускал только часть анализа макета и принимал определенную форму изображения. Возможные варианты для N:
  0 = только ориентация и обнаружение сценария (OSD).
  1 = Автоматическая сегментация страниц с экранным меню.
  2 = Автоматическая сегментация страниц, но без OSD или OCR. (не реализована)
  3 = Полностью автоматическая сегментация страниц, но без экранного меню. (Дефолт)
  4 = Предположим, что один столбец текста переменного размера.
  5 = Предположим, что один однородный блок вертикально выровненного текста.
  6 = Предположим, что это один однородный блок текста.
  7 = рассматривать изображение как одну текстовую строку.
  8 = рассматривать изображение как одно слово.
  9 = рассматривать изображение как отдельное слово в круге.
 10 = рассматривать изображение как один символ.
 11 = Редкий текст. Найдите как можно больше текста в произвольном порядке.
 12 = Разреженный текст в экранном меню.
 13 = Сырая линия. Рассматривайте изображение как одну текстовую строку, обход хаков, специфичных для Tesseract.
";ES;fi;;
 11) S=M11;SC;if [[ $cur == enter ]];then R;echo "
 Укажите режим OCR Engine. Возможные варианты для N:
  0 = только оригинальный Тессеракт.
  1 = только нейронные сети LSTM.
  2 = Тессеракт + LSTM.
  3 = По умолчанию, в зависимости от того, что доступно.
";ES;fi;;
 12) S=M12;SC;if [[ $cur == enter ]];then R;echo " Укажите расположение пути к tessdata.";ES;fi;;
 13) S=M13;SC;if [[ $cur == enter ]];then R;echo " Укажите расположение файла пользовательских шаблонов.";ES;fi;;
 14) S=M14;SC;if [[ $cur == enter ]];then R;echo " Укажите расположение файла пользовательских слов.";ES;fi;;
#
 15) S=M15;SC;if [[ $cur == enter ]];then R;clear;exit 0;fi;;
 esac;POS;done
