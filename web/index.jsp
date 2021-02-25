<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="ru">
<head>
    <title>Lab1</title>
    <meta charset="UTF-8">
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap-grid.min.css">
    <style>
        body {
            background-color: #e6e6e6;
        }

        input {
            width: 130px !important;
        }

        button {
            width: 150px !important;
        }

        #mainContent {
            width: 1425px;
            margin: 0 auto;
        }

        .form-control {
            display: inline !important;
        }

        #firstTable input {
            background-color: #8f99a3;
            color: white;
            border: none;
        }

        #firstTable td:not(:first-child) input {
            width: 90px !important;
        }

        .disabled {
            background-color: #65707b !important;
            color: #d4f2ff !important;
            border: none;
        }

        input[type=number]::-webkit-inner-spin-button,
        input[type=number]::-webkit-outer-spin-button {
            -webkit-appearance: none;
        }

        input[type=number] {
            -moz-appearance: textfield;
        }

        #firstTable, #firstCalcTable, #firstCalcTable2 {
            float: left;
        }

        #firstTable input, #firstCalcTable input, #firstCalcTable2 input, #secondTableAlternative input, #superResultTable input {
            background-color: #8f99a3;
            color: white;
            border: none;
        }

        #superResultTable {
            width: 265px;
            margin: 0 auto;
        }

        #firstCalcTable td input {
            width: 110px !important;
        }

        #firstCalcTable2 td input {
            width: 150px !important;
        }

        #secondTableAlternative td:nth-child(-n+6) input{
            width: 90px !important;
        }

        #secondTableAlternative  td:first-child input {
            width: 130px !important;
        }

        .max-value {
            background-color: #00fead !important;
        }

    </style>
</head>
<body>
<div id="mainContent">
    <div class="row">
        <div class="col-sm-5">
            <label>
                <input class="form-control form-control-sm" type="number" id="nElem" max="9" value="6"
                       style="font-family: Verdana; font-size: 12px; width: 50px;"> Матриця N x N </label>
        </div>
        <div class="col-sm-7">
            <label>
                <input class="form-control form-control-sm" type="number" id="nAlterSolutions" value="5"
                       style="font-family: Verdana; font-size: 12px; width: 50px;"> Кількість альтернатив </label>
        </div>

    </div>
    <div class="row">
        <div class="col-sm-5">
            <button class="btn btn-dark btn-sm" id="create" onclick="addTable();" style="margin: 5px 15px">Створити матрицю
            </button>

            <button class="btn btn-dark btn-sm" id="calc"
                    onclick="calculate();vectorsTable();calculateSelfVector();calculatePrioritetVector();lamdaMax();consistencyTable();calculateConsistency();calculateRandomConsistency();deleteDisable();this.disabled = true;"
                    style="margin: 5px 15px">Обрахувати
            </button>
        </div>
        <div class="col-sm-7">
            <button class="btn btn-dark btn-sm" id="createAlterTables" disabled="disabled" onclick="allAlternatives();this.disabled = true;"
                    style="margin: 5px 15px">Створити альтернативи
            </button>
            <button class="btn btn-dark btn-sm" id="cAlt"
                    onclick="this.disabled = true; calcAltSum();calcAltSelfVector();calcAltSelfVectorSum();calcAltPrioritetVector();calcAltPrioritetVectorSum();calcAltLamdaMax();calcAltLamdaMaxSum();calcAltUzgodj();calcAltRandomUzgodj();superResultTable();calcSuperResult();"
                    style="margin: 5px 15px">Обрахувати альтернативи
            </button>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12">
            <div id="firstTable"></div>
            <div id="firstCalcTable"></div>
            <div id="firstCalcTable2"></div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12">
            <div id="secondTableAlternative"></div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12">
            <div id="superResultTable"></div>
        </div>
    </div>
    <script>

        function addTable() {
            //<button id="dest" onclick="destroyTable();" style="background-color: red; margin: 5px 15px">Clear</button>
            var body = document.querySelector('#firstTable'),
                numElement = document.getElementById("nElem"),
                tmpN = numElement.value,
                n = ++tmpN,
                nRow = n++,
                tr = "",
                td = "",
                firstTable = document.querySelector("table");

            //console.log(n);
            //console.log(nRow);

            tableF = document.createElement("table");
            tableF.setAttribute('class', 'table table-sm');
            // table.setAttribute("border", "2px");
            // table.setAttribute("width", 800);
            // table.setAttribute("height", 400);


            for (var i = 0; i < n; i++) {
                tr = document.createElement("tr");//stroka
                for (var j = 0; j < nRow; j++) {
                    td = document.createElement("td");//stolb
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute('id', i + "" + j);
                    if (i == 0 && j == 0) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', '');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (i == nRow && j == 0) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', 'Сумма');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (i == j) {
                        inputInfo.setAttribute('type', 'number');
                        inputInfo.setAttribute('value', '1');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if ((i == 0 && j > 0) || (i > 0 && j == 0)) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('size', '10');
                        inputInfo.addEventListener("keypress", autoChangeText);
                    } else if (i == nRow && j > 0) {                     //summ place
                        inputInfo.setAttribute('type', 'number');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (!(i == 0 && j > 0) || (i > 0 && j == 0)) {
                        inputInfo.className = "auto-changable";
                        inputInfo.addEventListener("keypress", autoChange);
                        inputInfo.addEventListener("keyup", deleteChange);
                    } else {
                        inputInfo.setAttribute('type', 'number');
                        inputInfo.setAttribute('min', '1');
                        inputInfo.setAttribute('max', '10');
                    }

                    //text = document.createTextNode(i + "." + j );//vnytryanka
                    //td.appendChild(text);
                    td.appendChild(inputInfo);
                    tr.appendChild(td);

                }
                tableF.appendChild(tr);
            }

            //console.log(tr);
            //console.log(td);

            if (firstTable == null) {
                body.appendChild(tableF);
            } else {
                var newTable = body.appendChild(tableF);
                document.body.replaceChild(newTable, firstTable);
            }

            $.each($('input'), function (index, data) {
                if (data.getAttribute('disabled')) {
                    data.setAttribute('class', 'disabled')
                }
            })
        }

        function autoChangeText(event) {
            var value = event.target.value + String.fromCharCode(event.keyCode);
            var id = event.target.id;
            var key = event.keyCode || event.charCode;
            document.getElementById(id[1] + id[0]).value = value;
        }

        function autoChange(event) {
            var value = parseInt(event.target.value + String.fromCharCode(event.keyCode));
            var id = event.target.id;
            var key = event.keyCode || event.charCode;
            if (value >= 1) {
                document.getElementById(id[1] + id[0]).value = 1 / value;
            } else {
                document.getElementById(id[1] + id[0]).value =  value;
            }

        }

        function deleteChange(event) {
            var value = event.target.value + String.fromCharCode(event.keyCode);
            var id = event.target.id;
            var key = event.keyCode || event.charCode;

            if ((key == 8 || key == 46)) {
                document.getElementById(id[1] + id[0]).value = 1 / parseInt(value.substring(0, value.length - 1));
            }
        }

        function calculate() {
            var numElement = document.getElementById("nElem"),
                tmpN = parseInt(numElement.value),
                maxElem = tmpN * 11;

            //Sum in firstTable begin

            for (var i = 0; i < tmpN; i++) {
                var sum = 0;
                for (var j = 11 + i; j <= maxElem; j = j + 10) {
                    var numberFromCell = document.getElementById(j).value;
                    var sum = eval(sum) + eval(numberFromCell);
                }
                var sumId = i + 1 + (10 * (tmpN + 1));
                //console.log(sumId);
                document.getElementById(sumId).value = sum;
            }

            //Sum in firstTable end

        }

        function vectorsTable() {
            //VectorsTable begin
            var numElement = document.getElementById("nElem"),
                tmpN = parseInt(numElement.value),
                maxElem = tmpN * 11;

            var body = document.querySelector('#firstCalcTable'),
                tr = "",
                td = "",
                nRow = tmpN + 2,
                secondTable = document.querySelector("table2");
            table = document.createElement('table');
            table.setAttribute('class', 'table table-sm table-dark');
            table2 = document.createElement("table2");

            for (var i = 0; i < nRow; i++) {
                tr = document.createElement("tr");//stroka
                for (var j = 0; j < 3; j++) {
                    td = document.createElement("td");//stolb
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute('id', "vectors" + i + j);

                    if (i == 0 && j == 0) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', 'Власний вектор');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (i == 0 && j == 1) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', 'Вектор пріорітетів');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (i == 0 && j == 2) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', 'λmax');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (i == tmpN + 1) {
                        inputInfo.setAttribute('style', "background-color:MediumSeaGreen;");
                        inputInfo.setAttribute('type', 'number');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else {
                        inputInfo.setAttribute('type', 'number');
                        inputInfo.setAttribute('disabled', "disabled");
                        inputInfo.setAttribute('class', "disabled");
                    }

                    td.appendChild(inputInfo);
                    tr.appendChild(td);

                }
                table.appendChild(tr);
                document.querySelector('#firstCalcTable').appendChild(table)
            }

            if (secondTable == null) {
                return body.appendChild(table2);
            } else {
                var newTable = body.appendChild(table2);
                return document.body.replaceChild(newTable, secondTable);
            }
            //VectorsTable end
        }


        function calculateSelfVector() {
            //SelfVectorCalculate begin
            var numElement = document.getElementById("nElem"),
                tmpN = parseInt(numElement.value),
                maxElem = tmpN * 11;

            for (var i = 1; i <= tmpN; i++) {
                var selfVectorMultiple = 1;
                for (var j = 1; j <= tmpN; j++) {
                    var idCell = i + "" + j;
                    var numberFromCell = document.getElementById(idCell).value;

                    var selfVectorMultiple = eval(selfVectorMultiple) * eval(numberFromCell);
                }
                var selfVectorResult = Math.pow(selfVectorMultiple, 1 / tmpN);
                var id = i * 10;
                var selfVectorResultId = "vectors" + id;
                document.getElementById(selfVectorResultId).value = selfVectorResult;
            }
            //SelfVectorCalculate end

            //SelfVector Sum begin

            for (var i = 0; i < tmpN; i++) {
                var sum = 0;
                for (var j = 10; j <= maxElem; j = j + 10) {
                    var numberFromCell = document.getElementById("vectors" + j).value;
                    var sum = eval(sum) + eval(numberFromCell);
                }
                var sumId = "vectors" + (tmpN + 1) * 10;
                //console.log(sumId);
                document.getElementById(sumId).value = sum;
            }

            //SelfVector Sum end
        }

        function calculatePrioritetVector() {
            //PrioritetVectorCalculate begin
            var numElement = document.getElementById("nElem"),
                tmpN = parseInt(numElement.value),//7
                deviderId = (tmpN + 1) * 10,
                maxElem = tmpN * 11;
            var prioritetVectorResult = 0;

            for (var j = 10; j < tmpN * 11; j = j + 10) {
                var numberFromCell = document.getElementById("vectors" + j).value;
                var devider = document.getElementById("vectors" + deviderId).value;
                var prioritetVectorResult = eval(numberFromCell) / eval(devider);

                var prioritetVectorResultId = "vectors" + (j + 1);
                document.getElementById(prioritetVectorResultId).value = prioritetVectorResult;
            }
            //PrioritetVectorCalculate end

            //PrioritetVector Sum begin

            for (var i = 0; i < tmpN; i++) {
                var sum = 0;
                for (var j = 11; j <= maxElem; j = j + 10) {
                    var numberFromCell = document.getElementById("vectors" + j).value;
                    var sum = eval(sum) + eval(numberFromCell);
                }
                var sumId = "vectors" + (((tmpN + 1) * 10) + 1);
                //console.log(sumId);
                document.getElementById(sumId).value = sum;
            }

            //PrioritetVector Sum end
        }

        function lamdaMax() {
            //LamdaMax begin
            var numElement = document.getElementById("nElem"),
                tmpN = parseInt(numElement.value),//7
                maxElem = tmpN * 11,//77
                count = 1;

            var lamdaMaxResult = 0;

            for (var j = 11; j < tmpN * 11; j = j + 10) {

                var numberFromCell = document.getElementById("vectors" + j).value;

                var firstTableSum = document.getElementById(((tmpN + 1) * 10) + count).value;
                count++;

                lamdaMaxResult = eval(numberFromCell) * eval(firstTableSum);

                var lamdaMaxResultId = "vectors" + (j + 1);
                document.getElementById(lamdaMaxResultId).value = lamdaMaxResult;

            }
            //LamdaMax end

            //LamdaMax Sum begin

            for (var i = 0; i < tmpN; i++) {
                var sum = 0;
                for (var j = 12; j <= maxElem; j = j + 10) {
                    var numberFromCell = document.getElementById("vectors" + j).value;
                    var sum = eval(sum) + eval(numberFromCell);
                }
                var sumId = "vectors" + (((tmpN + 1) * 10) + 2);
                //console.log(sumId);
                document.getElementById(sumId).value = sum;
            }

            //LamdaMax Sum end
        }

        function consistencyTable() {
            var body = document.querySelector("body").children[0],
                tr = "",
                td = "",
                thirdTable = document.querySelector("table3");
            var tableC = document.createElement('table');
            tableC.setAttribute('class', 'table table-sm table-dark');
            table3 = document.createElement("table3");

            for (var i = 0; i < 2; i++) {
                tr = document.createElement("tr");//stroka
                for (var j = 0; j < 2; j++) {
                    td = document.createElement("td");//stolb
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute('id', "consistency" + i + j);

                    if (i == 0 && j == 0) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', 'Індекс узгодженсті');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (i == 0 && j == 1) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', 'Відношення узгодженості');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else {
                        inputInfo.setAttribute('type', 'number');
                        inputInfo.setAttribute('disabled', "disabled");
                        inputInfo.setAttribute('class', "disabled");
                    }

                    td.appendChild(inputInfo);
                    tr.appendChild(td);
                }
                tableC.appendChild(tr);
                document.querySelector('#firstCalcTable2').appendChild(tableC)
            }

            if (thirdTable == null) {
                return body.appendChild(table3);
            } else {
                var newTable = body.appendChild(table3);
                return document.body.replaceChild(newTable, thirdTable);
            }
        }

        function calculateConsistency() {
            //calculateConsistency begin
            var numElement = document.getElementById("nElem"),
                tmpN = parseInt(numElement.value),//7
                maxElem = tmpN * 11;//77

            var consistencyResult = 0;
            var idLambaMaxSum = (((tmpN + 1) * 10) + 2);

            var numberFromCell = document.getElementById("vectors" + idLambaMaxSum).value;

            consistencyResult = (numberFromCell - tmpN) / (tmpN - 1);

            var consistencyResultId = "consistency" + (10);
            document.getElementById(consistencyResultId).value = consistencyResult;


            //calculateConsistency end
        }

        function calculateRandomConsistency() {
            //calculateRandomConsistency begin
            var numElement = document.getElementById("nElem"),
                tmpN = parseInt(numElement.value),//7
                maxElem = tmpN * 11;//77

            var randomConsistencyResult = 0;
            var consistencyResultId = 10;
            var staticRandomConsistencyArray = [0, 0, 0.58, 0.9, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49];
            var staticRandomConsistency = staticRandomConsistencyArray[tmpN - 1];

            var numberFromCell = document.getElementById("consistency" + consistencyResultId).value;

            randomConsistencyResult = (numberFromCell / staticRandomConsistency) * 100;

            var randomConsistencyResultID = "consistency" + (11);
            document.getElementById(randomConsistencyResultID).value = randomConsistencyResult;


            //calculateRandomConsistency end
        }

        function deleteDisable() {
            document.getElementById('createAlterTables').removeAttribute('disabled');
        }

        function destroyTable() {

        }

        function autoChangeAlternativesLabel(event) {
            var value = event.target.value + String.fromCharCode(event.keyCode);
            var id = event.target.id;
            var key = event.keyCode || event.charCode;

            var rowIndex = id.indexOf("_");
            var inputIndex = id.lastIndexOf("_");
            var tableIndex = id.substring(rowIndex + 1, inputIndex);

            var table = id.substring(0, rowIndex);
            var row = id.substring(rowIndex + 1, inputIndex);
            var input = id.substring(inputIndex + 1, id.length);
            var newId = "_" + input + "_" + row;
            var oldId = "_" + row + "_" + input;

            var numElement = document.getElementById("nElem");
            var tmpN = numElement.value;
            for (var i = 1; i <= tmpN; i++) {
                document.getElementById(i + newId).value = value;
                if(id !== (i + oldId)) {
                    document.getElementById(i + oldId).value = value;
                }
            }
        }

        function autoChangeAlternatives(event) {
            var value = parseInt(event.target.value + String.fromCharCode(event.keyCode));
            var id = event.target.id;
            var key = event.keyCode || event.charCode;

            var rowIndex = id.indexOf("_");
            var inputIndex = id.lastIndexOf("_");
            var tableIndex = id.substring(rowIndex + 1, inputIndex);

            var table = id.substring(0, rowIndex);
            var row = id.substring(rowIndex + 1, inputIndex);
            var input = id.substring(inputIndex + 1, id.length);
            var newId = table + "_" + input + "_" + row;
            document.getElementById(newId).value = 1 / value;
        }


        function deleteChangeAlternatives(event) {
            var value = event.target.value + String.fromCharCode(event.keyCode);
            var id = event.target.id;
            var key = event.keyCode || event.charCode;


            if ((key == 8 || key == 46)) {
                var rowIndex = id.indexOf("_");
                var inputIndex = id.lastIndexOf("_");
                var tableIndex = id.substring(rowIndex + 1, inputIndex);

                var table = id.substring(0, rowIndex);
                var row = id.substring(rowIndex + 1, inputIndex);
                var input = id.substring(inputIndex + 1, id.length);
                var newId = table + "_" + input + "_" + row;
                document.getElementById(newId).value = 1 / parseInt(value.substring(0, value.length - 1));
            }
        }

        function allAlternatives() {
            document.querySelector("#createAlterTables").setAttribute('disabled', 'disabled');
            var body = document.querySelector("body").children[0];
            var numElement = document.getElementById("nElem");
            var tmpN = numElement.value;

            var items = document.getElementById("nAlterSolutions");
            var tmpItems = items.value;

            var table = document.createElement("table");
            table.className = "alternatives";
            // $("body").append(table);
            $('#mainContent').append(table);
            var alternativesRootTable = document.querySelector("table.alternatives");

            for (var i = 1; i <= tmpN; i++) {
                var table = document.createElement("table");
                table.setAttribute("id", "alternative_" + i);
                table.setAttribute('class', 'table table-sm table-dark');
                for (var j = 0; j <= tmpItems; j++) {
                    var tr = document.createElement("tr");//stroka
                    for (var k = 0; k <= tmpItems; k++) {
                        var td = document.createElement("td");//stolb
                        // td.setAttribute("style", "padding-top: 10px; padding-bottom: 10px;");
                        var inputInfo = document.createElement("input");
                        if ((k != 0 && j != 0) && (k == j)) {
                            inputInfo.setAttribute("disabled", "disabled");
                            inputInfo.value = 1;
                        }

                        if (k == 0 && j == 0) {
                            var name = document.getElementById("0" + i);
                            inputInfo.setAttribute("disabled", "disabled");
                            inputInfo.setAttribute('value', name.value);
                        }

                        if (k != 0 && j != 0) {
                            inputInfo.addEventListener("keypress", autoChangeAlternatives);
                            inputInfo.addEventListener("keyup", deleteChangeAlternatives);
                        } else {
                            inputInfo.setAttribute("type", "text");
                            inputInfo.addEventListener("keypress", autoChangeAlternativesLabel);
                        }

                        inputInfo.setAttribute("id", i + "_" + j + "_" + k);
                        //inputInfo.setAttribute("value",i+"_"+j+"_"+k);

                        td.appendChild(inputInfo);

                        tr.appendChild(td);
                    }
                    table.appendChild(tr);
                }
                var trSum = document.createElement("tr");
                for (var kk = 0; kk <= tmpItems; kk++) {

                    var td = document.createElement("td");
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute("id", i + "_sum_" + kk);
                    //inputInfo.setAttribute("value",i+"_sum_"+kk);
                    inputInfo.setAttribute("disabled", "disabled");

                    if (kk != 0) {
                        inputInfo.setAttribute("style", "background-color:MediumSeaGreen");
                    } else {
                        inputInfo.value = "Сумма";
                    }
                    td.appendChild(inputInfo);
                    trSum.appendChild(td);
                }
                table.appendChild(trSum);
                table.setAttribute("style", "border:1px solid black");

                for (var z = 0; z < table.rows.length; z++) {
                    var td = document.createElement("td");
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute("disabled", "disabled");

                    if (z == 0) {
                        inputInfo.value = "Власний вектор";
                    }
                    td.appendChild(inputInfo);
                    table.rows[z].appendChild(td);
                    if (z == table.rows.length - 1) {
                        inputInfo.setAttribute("id", i + "_sum_" + eval(1 * tmpItems + 1));
                        inputInfo.setAttribute("value", i + "_sum_" + eval(1 * tmpItems + 1));
                        inputInfo.setAttribute("style", "background-color:MediumSeaGreen");
                    } else {
                        inputInfo.setAttribute("id", i + "_vv_" + z);
                    }
                }

                for (var z = 0; z < table.rows.length; z++) {
                    var td = document.createElement("td");
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute("disabled", "disabled");

                    if (z == 0) {
                        inputInfo.value = "Вектор пріоритетів";
                    }
                    td.appendChild(inputInfo);
                    table.rows[z].appendChild(td);
                    if (z == table.rows.length - 1) {
                        inputInfo.setAttribute("id", i + "_sum_" + eval(1 * tmpItems + 2));
                        inputInfo.setAttribute("value", i + "_sum_" + eval(1 * tmpItems + 2));
                        inputInfo.setAttribute("style", "background-color:MediumSeaGreen");
                    } else {
                        inputInfo.setAttribute("id", i + "_vp_" + z);
                    }
                }

                for (var z = 0; z < table.rows.length; z++) {
                    var td = document.createElement("td");
                    var inputInfo = document.createElement("input");
                    td.appendChild(inputInfo);
                    table.rows[z].appendChild(td);
                    inputInfo.setAttribute("disabled", "disabled");

                    if (z == 0) {
                        inputInfo.value = "λmax";
                        inputInfo.setAttribute("disabled", "disabled");
                    }
                    if (z == table.rows.length - 1) {
                        inputInfo.setAttribute("id", i + "_sum_" + eval(1 * tmpItems + 3));
                        inputInfo.setAttribute("value", i + "_sum_" + eval(1 * tmpItems + 3));
                        inputInfo.setAttribute("style", "background-color:MediumSeaGreen");
                    } else {
                        inputInfo.setAttribute("id", i + "_lmax_" + z);
                    }
                }


                for (var z = 0; z < 2; z++) {
                    var td = document.createElement("td");
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute("disabled", "disabled");

                    if (z == 0) {
                        inputInfo.value = "Індекс Узгодженості";
                    } else {
                        inputInfo.setAttribute("id", i + "_uzgodj_" + z);
                    }
                    td.appendChild(inputInfo);
                    table.rows[z].appendChild(td);
                }

                for (var z = 0; z < 2; z++) {
                    var td = document.createElement("td");
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute("disabled", "disabled");

                    if (z == 0) {
                        inputInfo.value = "Відношення узгодженості";
                    } else {
                        inputInfo.setAttribute("id", i + "_randomuzgodj_" + z);
                    }
                    td.appendChild(inputInfo);
                    table.rows[z].appendChild(td);
                }


                // $("body").append(table);
                $('#secondTableAlternative').append(table);

                $.each($('input'), function (index, data) {
                    if (data.getAttribute('disabled')) {
                        data.setAttribute('class', 'disabled')
                    }
                });

                $("body").append("<br/><br/><br/>");
            }
        }

        function calcAltSum() {
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4


            for (var i = 1; i <= tmpN; i++) {
                for (var j = 1; j <= tmpAlters; j++) {//trigger
                    var sum = 0;
                    for (var z = 1; z <= tmpAlters; z++) {
                        var numberFromCell = document.getElementById('alternative_' + i).rows[z].cells[j].children[0].value;
                        sum = eval(sum) + eval(numberFromCell);
                    }
                    var sumId = i + "_sum_" + j;
                    document.getElementById(sumId).value = sum;
                    sum = 0;
                }
            }
        }

        function calcAltSelfVector() {//1_vv_1
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4


            for (var i = 1; i <= tmpN; i++) {
                for (var j = 1; j <= tmpAlters; j++) {//trigger
                    var mult = 1;
                    for (var z = 1; z <= tmpAlters; z++) {
                        var numberFromCell = document.getElementById('alternative_' + i).rows[j].cells[z].children[0].value;
                        mult = eval(mult) * eval(numberFromCell);
                    }
                    var result = Math.pow(mult, 1 / tmpAlters);

                    var resultId = i + "_vv_" + j;
                    document.getElementById(resultId).value = result;
                    mult = 1;
                }
            }
        }

        function calcAltSelfVectorSum() {//1_vv_1
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4
            var idSumVV = ++tmpAlters;

            for (var i = 1; i <= tmpN; i++) {
                var sum = 0;
                for (var j = 1; j < tmpAlters; j++) {//trigger

                    var numberFromCell = document.getElementById(i + "_vv_" + j).value;
                    sum = eval(sum) + eval(numberFromCell);

                }
                var sumId = i + "_sum_" + idSumVV;
                document.getElementById(sumId).value = sum;
            }
        }

        function calcAltPrioritetVector() {
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4
            var idSumVV = ++tmpAlters;

            for (var i = 1; i <= tmpN; i++) {//1_vp_1
                var sumVV = document.getElementById(i + "_sum_" + idSumVV).value;
                var result = 0;
                var resultId;
                for (var j = 1; j < tmpAlters; j++) {//trigger
                    var numberFromCell = document.getElementById(i + "_vv_" + j).value;
                    result = eval(numberFromCell) / eval(sumVV);
                    resultId = i + "_vp_" + j;
                    document.getElementById(resultId).value = result;
                }
            }
        }

        function calcAltPrioritetVectorSum() {
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4
            var idSumVP = tmpAlters + 2;

            for (var i = 1; i <= tmpN; i++) {
                var sum = 0;
                for (var j = 1; j <= tmpAlters; j++) {//trigger

                    var numberFromCell = document.getElementById(i + "_vp_" + j).value;
                    sum = eval(sum) + eval(numberFromCell);

                }
                var sumId = i + "_sum_" + idSumVP;
                document.getElementById(sumId).value = sum;
            }
        }

        function calcAltLamdaMax() {
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4

            for (var i = 1; i <= tmpN; i++) {//1_vp_1
                var mult = 1;
                for (var j = 1; j <= tmpAlters; j++) {//trigger
                    var numberFromCell = document.getElementById(i + "_vp_" + j).value;
                    var collSum = document.getElementById(i + "_sum_" + j).value;

                    mult = eval(numberFromCell) * eval(collSum);
                    var lmaxId = i + "_lmax_" + j;
                    document.getElementById(lmaxId).value = mult;
                }
            }
        }

        function calcAltLamdaMaxSum() {
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4
            var idSumLMAX = tmpAlters + 3;

            for (var i = 1; i <= tmpN; i++) {
                var sum = 0;
                for (var j = 1; j <= tmpAlters; j++) {//trigger

                    var numberFromCell = document.getElementById(i + "_lmax_" + j).value;
                    sum = eval(sum) + eval(numberFromCell);

                }
                var sumId = i + "_sum_" + idSumLMAX;
                document.getElementById(sumId).value = sum;
            }
        }

        function calcAltUzgodj() {
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4
            var idSumLMAX = tmpAlters + 3;

            for (var i = 1; i <= tmpN; i++) {//1_vp_1
                var result = 0;
                var numberFromCell = document.getElementById(i + "_sum_" + idSumLMAX).value;

                result = (eval(numberFromCell) - eval(tmpAlters)) / (eval(tmpAlters - 1));
                var uzgodjId = i + "_uzgodj_" + 1;
                document.getElementById(uzgodjId).value = result;

            }
        }

        function calcAltRandomUzgodj() {
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4
            var staticRandomConsistencyArray = [0, 0, 0.58, 0.9, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49];
            var staticRandomConsistency = staticRandomConsistencyArray[tmpAlters - 1];//0.9

            for (var i = 1; i <= tmpN; i++) {
                var result = 0;
                var numberFromCell = document.getElementById(i + "_uzgodj_" + 1).value;

                result = (eval(numberFromCell) / eval(staticRandomConsistency)) * 100;
                var randomUzgodjId = i + "_randomuzgodj_" + 1;
                document.getElementById(randomUzgodjId).value = result;

            }
        }

        function superResultTable() {
            var body = document.querySelector("body").children[0],
                tr = "",
                td = "",
                thirdTable = document.querySelector("table");

            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4

            var table = document.createElement("table");
            table.className = "superResult";
            // $("body").append(table);

            var alternativesRootTable = document.querySelector("table.superResult");

            for (var i = 0; i <= tmpAlters; i++) {
                tr = document.createElement("tr");//stroka
                for (var j = 0; j < 2; j++) {
                    td = document.createElement("td");//stolb
                    var inputInfo = document.createElement("input");
                    inputInfo.setAttribute('id', "resultOfAll_" + i + "_" + j);

                    if (i == 0 && j == 0) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', 'Name');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (i == 0 && j == 1) {
                        inputInfo.setAttribute('type', 'text');
                        inputInfo.setAttribute('value', 'Result');
                        inputInfo.setAttribute('disabled', "disabled");
                    } else if (i >= 0 && j == 0) {
                        var altName = document.getElementById("1_0_" + i);
                        inputInfo.setAttribute('disabled', "disabled");
                        inputInfo.setAttribute('value', altName.value);
                    } else {
                        inputInfo.setAttribute('type', 'number');
                        inputInfo.setAttribute('disabled', "disabled");
                    }

                    td.appendChild(inputInfo);
                    tr.appendChild(td);
                }
                table.appendChild(tr);
            }

            // $("body").append(table);
            $('#superResultTable').append(table);
            $.each($('input'), function (index, data) {
                if (data.getAttribute('disabled')) {
                    data.setAttribute('class', 'disabled')
                }
            })
            $("body").append("<br/><br/><br/>");
        }

        function calcSuperResult() {
            var numElement = document.getElementById("nElem");
            var tmpN = parseInt(numElement.value);//7
            var numAlter = document.getElementById("nAlterSolutions");
            var tmpAlters = parseInt(numAlter.value);//4
            var maxValue = 0;
            var maxValueIndex = '';
            for (var j = 1; j <= tmpAlters; j++) {//trigger
                var mult = 1;
                var sum = 0;
                for (var z = 1; z <= tmpN; z++) {
                    var mainTableNum = document.getElementById("vectors" + z + 1).value;//static
                    var numberFromCell = document.getElementById(z + "_vp_" + j).value;

                    mult = eval(mainTableNum) * eval(numberFromCell);
                    sum = eval(sum) + eval(mult);
                }
                if(sum > maxValue) {
                    maxValue = sum;
                    maxValueIndex = "resultOfAll_" + j + "_1";
                }

                var superResultId = "resultOfAll_" + j + "_1";//resultOfAll_1_1
                document.getElementById(superResultId).value = sum;
            }

            document.getElementById(maxValueIndex).setAttribute('class', 'max-value')
        }

    </script>
</div>
</body>
</html>

