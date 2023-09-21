import 'package:amusevr_assist/pages/home_page.dart';
import 'package:flutter/material.dart';

class CustomStep {
  final int stepNumber;
  final Widget content;

  CustomStep({required this.stepNumber, required this.content});
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int currentStep = 0;
  List<CustomStep> steps = [
    CustomStep(
      stepNumber: 0,
      content: Column(
        children: [
          Image.asset(
            'assets/images/settings.png',
            width: 60,
            height: 60,
          ),
          SizedBox(height: 20),
          Text("Este é um aplicativo para configurar o AMUSEVR"),
        ],
      ),
    ),
    CustomStep(
      stepNumber: 1,
      content: Column(
        children: [
          Image.asset(
            'assets/images/settings.png',
            width: 60,
            height: 60,
          ),
          SizedBox(height: 20),
          Text("Com ele você poderá configurar o ESP para se conectar a sua rede Wi-Fi"),
        ],
      ),
    ),
    CustomStep(
      stepNumber: 2,
      content: Column(
        children: [
          Image.asset(
            'assets/images/settings.png',
            width: 60,
            height: 60,
          ),
          SizedBox(height: 20),
          Text("O ESP é responsável por controlar os periféricos como luz e ventilador"),
        ],
      ),
    )
  ];

  void goToNextStep({bool skip = false}) {
    if (skip) {
      setState(() {
        currentStep = steps.length - 1;
      });
    }
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep += 1;
        if (currentStep >= steps.length) {
          currentStep = steps.length - 1;
        }
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void goToPreviousStep() {
    setState(() {
      currentStep -= 1;
      if (currentStep < 0) {
        currentStep = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo ao AmuseVR Assist'),
      ),
      body: Stepper(
          type: StepperType.horizontal,
          elevation: 0,
          currentStep: currentStep,
          steps: steps.map((step) {
            return Step(
              title: const SizedBox.shrink(),
              content: step.content,
              isActive: currentStep >= step.stepNumber,
            );
          }).toList(),
          onStepContinue: () => goToNextStep(),
          onStepCancel: () => goToPreviousStep(),
          onStepTapped: (index) {
            setState(() {
              if (index < currentStep) {
                currentStep = index;
              }
            });
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return const SizedBox.shrink();
          }),
      bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility.maintain(
                visible: currentStep > 0,
                child: ElevatedButton(
                  onPressed: () => goToPreviousStep(),
                  child: const Text('Voltar'),
                ),
              ),
              TextButton(
                onPressed: () => goToNextStep(skip: true),
                child: Text('Pular'),
              ),
              currentStep == steps.length - 1
                  ? ElevatedButton(
                      onPressed: () => goToNextStep(),
                      child: const Text('Finalizar'),
                    )
                  : ElevatedButton(
                      onPressed: () => goToNextStep(),
                      child: const Text('Próximo'),
                    ),
            ],
          )),
    );
  }
}
