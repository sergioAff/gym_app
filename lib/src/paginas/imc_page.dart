import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImcPage extends StatelessWidget {
  const ImcPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const ImcCalculator(),
    );
  }
}

class ImcCalculator extends StatefulWidget {
  const ImcCalculator({Key? key});

  @override
  _ImcCalculatorState createState() => _ImcCalculatorState();
}

class _ImcCalculatorState extends State<ImcCalculator> {
  // Controladores para los campos de texto
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  // Valores por defecto
  double height = 170.0; // cm
  double weight = 70.0; // kg
  double bmi = 0.0;
  bool hasCalculated = false;
  
  // Categoría IMC
  String _category = '';
  Color _categoryColor = Colors.green;
  String _healthRisk = '';
  String _recommendation = '';
  
  @override
  void initState() {
    super.initState();
    _heightController.text = height.toString();
    _weightController.text = weight.toString();
  }
  
  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
  
  void _calculateBMI() {
    try {
      setState(() {
        height = double.tryParse(_heightController.text) ?? 170.0;
        weight = double.tryParse(_weightController.text) ?? 70.0;
        
        // Convertir altura de cm a metros
        final heightInMeters = height / 100;
        // Calcular IMC
        bmi = weight / (heightInMeters * heightInMeters);
        
        // Establecer la categoría
        _setCategoryInfo();
        
        hasCalculated = true;
      });
    } catch (e) {
      print("Error al calcular IMC: $e");
      _showErrorDialog("No se pudo calcular el IMC. Por favor verifica los valores ingresados.");
    }
  }
  
  void _setCategoryInfo() {
    if (bmi < 16.0) {
      _category = 'Delgadez severa';
      _categoryColor = Colors.red;
      _healthRisk = 'Riesgo muy severo para la salud';
      _recommendation = 'Consulta a un médico urgentemente. Necesitas aumentar de peso de manera saludable.';
    } else if (bmi < 17.0) {
      _category = 'Delgadez moderada';
      _categoryColor = Colors.orange;
      _healthRisk = 'Riesgo severo para la salud';
      _recommendation = 'Consulta a un nutricionista. Necesitas una dieta balanceada para ganar peso.';
    } else if (bmi < 18.5) {
      _category = 'Delgadez leve';
      _categoryColor = Colors.amber;
      _healthRisk = 'Riesgo para la salud';
      _recommendation = 'Intenta incrementar tu consumo calórico con alimentos saludables.';
    } else if (bmi < 25.0) {
      _category = 'Peso normal';
      _categoryColor = Colors.green;
      _healthRisk = 'Riesgo normal';
      _recommendation = '¡Mantén tus hábitos saludables! Tu peso es adecuado para tu altura.';
    } else if (bmi < 30.0) {
      _category = 'Sobrepeso';
      _categoryColor = Colors.amber;
      _healthRisk = 'Riesgo aumentado';
      _recommendation = 'Considera incrementar tu actividad física y revisar tu dieta.';
    } else if (bmi < 35.0) {
      _category = 'Obesidad leve';
      _categoryColor = Colors.orange;
      _healthRisk = 'Riesgo moderado';
      _recommendation = 'Consulta a un profesional de la salud. Una dieta balanceada y ejercicio regular pueden ayudarte.';
    } else if (bmi < 40.0) {
      _category = 'Obesidad moderada';
      _categoryColor = Colors.deepOrange;
      _healthRisk = 'Riesgo severo';
      _recommendation = 'Busca ayuda profesional para establecer un plan de pérdida de peso seguro.';
    } else {
      _category = 'Obesidad mórbida';
      _categoryColor = Colors.red;
      _healthRisk = 'Riesgo muy severo';
      _recommendation = 'Requieres atención médica para manejar los riesgos asociados a la obesidad.';
    }
  }
  
  void _reset() {
    setState(() {
      height = 170.0;
      weight = 70.0;
      _heightController.text = height.toString();
      _weightController.text = weight.toString();
      bmi = 0.0;
      hasCalculated = false;
    });
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de Medidas
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tus Medidas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de altura
                    TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Altura (cm)',
                        prefixIcon: const Icon(Icons.height),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixText: 'cm',
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de peso
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Peso (kg)',
                        prefixIcon: const Icon(Icons.monitor_weight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixText: 'kg',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botones de cálculo y reset
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _calculateBMI,
                            icon: const Icon(Icons.calculate),
                            label: const Text('CALCULAR'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('RESET'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Resultado IMC
            if (hasCalculated)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tu IMC',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _categoryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _category,
                              style: TextStyle(
                                color: _categoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Valor del IMC
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: _categoryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  bmi.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: _categoryColor,
                                  ),
                                ),
                                const Text(
                                  'kg/m²',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Información sobre el riesgo
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: _categoryColor),
                                const SizedBox(width: 8),
                                Text(
                                  _healthRisk,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _categoryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(_recommendation),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            const SizedBox(height: 24),
            
            // Tabla de categorías simplificada
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categorías de IMC',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Barra de escala IMC
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.red,       // <16.0
                            Colors.orange,    // <17.0
                            Colors.amber,     // <18.5
                            Colors.green,     // <25.0
                            Colors.amber,     // <30.0
                            Colors.orange,    // <35.0
                            Colors.deepOrange, // <40.0
                            Colors.red,       // >=40.0
                          ],
                          stops: [0.0, 0.1, 0.2, 0.4, 0.6, 0.7, 0.8, 1.0],
                        ),
                      ),
                    ),
                    // Escala numérica
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('16', style: TextStyle(fontSize: 12)),
                          Text('18.5', style: TextStyle(fontSize: 12)),
                          Text('25', style: TextStyle(fontSize: 12)),
                          Text('30', style: TextStyle(fontSize: 12)),
                          Text('35', style: TextStyle(fontSize: 12)),
                          Text('40', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Lista de categorías simplificada
                    Column(
                      children: [
                        _buildCategoryRow('Delgadez severa', '< 16.0', Colors.red),
                        _buildCategoryRow('Delgadez moderada', '16.0 - 16.9', Colors.orange),
                        _buildCategoryRow('Delgadez leve', '17.0 - 18.4', Colors.amber),
                        _buildCategoryRow('Peso normal', '18.5 - 24.9', Colors.green),
                        _buildCategoryRow('Sobrepeso', '25.0 - 29.9', Colors.amber),
                        _buildCategoryRow('Obesidad leve', '30.0 - 34.9', Colors.orange),
                        _buildCategoryRow('Obesidad moderada', '35.0 - 39.9', Colors.deepOrange),
                        _buildCategoryRow('Obesidad mórbida', '≥ 40.0', Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Disclaimer
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.medical_information, color: theme.colorScheme.error),
                        const SizedBox(width: 8),
                        Text(
                          'Aviso Importante',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'El IMC es solo un indicador y puede no ser adecuado para todos los individuos. Consulta siempre a un profesional de la salud para una evaluación completa.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryRow(String category, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            range,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
