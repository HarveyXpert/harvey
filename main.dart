import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '0';
  String previousNumber = '';
  String operation = '';
  bool waitingForOperand = false;

  String formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  void toggleSign() {
    setState(() {
      if (display == '0') return;
      if (display.startsWith('-')) {
        display = display.substring(1);
      } else {
        display = '-$display';
      }
    });
  }

  void percent() {
    setState(() {
      double val = double.tryParse(display) ?? 0;
      val = val / 100.0;
      display = formatNumber(val);
    });
  }

  void inputNumber(String number) {
    setState(() {
      if (waitingForOperand) {
        display = number;
        waitingForOperand = false;
      } else {
        display = display == '0' ? number : display + number;
      }
    });
  }

  void inputOperation(String nextOperation) {
    double inputValue = double.parse(display);
    if (previousNumber.isEmpty) {
      previousNumber = formatNumber(inputValue);
    } else if (operation.isNotEmpty) {
      double previousValue = double.parse(previousNumber);
      double result = calculate(previousValue, inputValue, operation);
      setState(() {
        display = formatNumber(result);
        previousNumber = formatNumber(result);
      });
    }

    waitingForOperand = true;
    operation = nextOperation;
  }

  double calculate(
    double firstOperand,
    double secondOperand,
    String operation,
  ) {
    switch (operation) {
      case '+':
        return firstOperand + secondOperand;
      case '-':
        return firstOperand - secondOperand;
      case '×':
        return firstOperand * secondOperand;
      case '÷':
        return secondOperand != 0 ? firstOperand / secondOperand : 0;
      default:
        return secondOperand;
    }
  }

  void performCalculation() {
    double inputValue = double.parse(display);

    if (previousNumber.isNotEmpty && operation.isNotEmpty) {
      double previousValue = double.parse(previousNumber);
      double result = calculate(previousValue, inputValue, operation);

      setState(() {
        display = formatNumber(result);
        previousNumber = '';
        operation = '';
        waitingForOperand = true;
      });
    }
  }

  void clear() {
    setState(() {
      display = '0';
      previousNumber = '';
      operation = '';
      waitingForOperand = false;
    });
  }

  void inputDecimal() {
    setState(() {
      if (waitingForOperand) {
        display = '0.';
        waitingForOperand = false;
      } else if (!display.contains('.')) {
        display = '$display.';
      }
    });
  }

  Widget buildButton(String buttonText, {Color? color, Color? textColor}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],
            foregroundColor: textColor ?? Colors.black,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            if (buttonText == 'C') {
              clear();
            } else if (buttonText == '=') {
              performCalculation();
            } else if (['+', '-', '×', '÷'].contains(buttonText)) {
              inputOperation(buttonText);
            } else if (buttonText == '.') {
              inputDecimal();
            } else if (buttonText == '±') {
              toggleSign();
            } else if (buttonText == '%') {
              percent();
            } else {
              inputNumber(buttonText);
            }
          },
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0f2f1), Color(0xFFffffff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            // Display
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.fromLTRB(12, 18, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (previousNumber.isNotEmpty && operation.isNotEmpty)
                        Text(
                          '${previousNumber} $operation',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      Text(
                        display,
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Buttons
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  // Row 1
                  Expanded(
                    child: Row(
                      children: [
                        buildButton(
                          'C',
                          color: Colors.redAccent,
                          textColor: Colors.white,
                        ),
                        buildButton('±', color: Colors.grey[300]),
                        buildButton('%', color: Colors.grey[300]),
                        buildButton(
                          '÷',
                          color: Colors.indigo,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // Row 2
                  Expanded(
                    child: Row(
                      children: [
                        buildButton('7'),
                        buildButton('8'),
                        buildButton('9'),
                        buildButton(
                          '×',
                          color: Colors.indigo,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // Row 3
                  Expanded(
                    child: Row(
                      children: [
                        buildButton('4'),
                        buildButton('5'),
                        buildButton('6'),
                        buildButton(
                          '-',
                          color: Colors.indigo,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // Row 4
                  Expanded(
                    child: Row(
                      children: [
                        buildButton('1'),
                        buildButton('2'),
                        buildButton('3'),
                        buildButton(
                          '+',
                          color: Colors.indigo,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // Row 5
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(4),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () => inputNumber('0'),
                              child: Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        buildButton('.'),
                        buildButton(
                          '=',
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
