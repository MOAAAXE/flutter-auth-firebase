import 'package:flutter/material.dart';

class RadiobuttonPage extends StatefulWidget {
  const RadiobuttonPage({super.key});

  @override
  _CompleteRadioButtonFormState createState() => _CompleteRadioButtonFormState();
}

class _CompleteRadioButtonFormState extends State<RadiobuttonPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();

  String? _selectedGender;
  String? _selectedJob;
  String? _selectedWorkType;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _jobOptions = [
    {'value': 'Admin', 'icon': Icons.support_agent, 'color': const Color(0xFF2196F3), 'description': 'Mengelola Data'},
    {'value': 'Guru', 'icon': Icons.school, 'color': const Color(0xFF9C27B0), 'description': 'Mendidik generasi'},
    {'value': 'Programmer', 'icon': Icons.code, 'color': const Color(0xFF4CAF50), 'description': 'Mengembangkan software'},
    {'value': 'Pengusaha', 'icon': Icons.business, 'color': const Color(0xFFF44336), 'description': 'Mengelola bisnis'},
    {'value': 'Desainer', 'icon': Icons.design_services, 'color': const Color(0xFF00BCD4), 'description': 'Kreativitas visual'},
  ];

  final List<Map<String, dynamic>> _workTypeOptions = [
    {'value': 'Full Time', 'subtitle': 'Bekerja 40 jam/minggu', 'icon': Icons.work, 'color': const Color(0xFF00897B), 'benefits': ['Asuransi kesehatan', 'Tunjangan hari raya']},
    {'value': 'Part Time', 'subtitle': 'Bekerja < 40 jam/minggu', 'icon': Icons.access_time, 'color': const Color(0xFF0288D1), 'benefits': ['Jadwal fleksibel', 'Liburan panjang']},
    {'value': 'Freelance', 'subtitle': 'Pekerja lepas', 'icon': Icons.laptop, 'color': const Color(0xFF7B1FA2), 'benefits': ['Kerja remote', 'Rate per project']},
    {'value': 'Kontrak', 'subtitle': 'Perjanjian waktu tertentu', 'icon': Icons.description, 'color': const Color(0xFFE65100), 'benefits': ['Bonus kontrak', 'Evaluasi berkala']},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _namaController.dispose();
    _umurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Form dengan RadioButton',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00695C),
                Color(0xFF00897B),
              ],
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Data Diri (Bagian yang sebelumnya terpotong)
                _buildModernSection('Data Diri', Icons.person_outline, [
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildModernTextField(
                            controller: _namaController,
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama Anda',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildModernTextField(
                            controller: _umurController,
                            label: 'Umur',
                            hint: 'Masukkan umur Anda',
                            icon: Icons.cake_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Umur tidak boleh kosong';
                              int? age = int.tryParse(value);
                              if (age == null || age < 17 || age > 100) return 'Umur harus antara 17-100 tahun';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),

                const SizedBox(height: 24),

                // RadioButton Jenis Kelamin
                _buildModernSection('Jenis Kelamin', Icons.people_outline, [
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildAnimatedGenderCard(
                                      title: 'Laki-laki',
                                      value: 'Laki-laki',
                                      groupValue: _selectedGender,
                                      icon: Icons.male,
                                      color: const Color(0xFF2196F3),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                                      ),
                                      onChanged: (value) {
                                        setState(() => _selectedGender = value);
                                        state.didChange(value);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildAnimatedGenderCard(
                                      title: 'Perempuan',
                                      value: 'Perempuan',
                                      groupValue: _selectedGender,
                                      icon: Icons.female,
                                      color: const Color(0xFFE91E63),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xFFE91E63), Color(0xFFF06292)],
                                      ),
                                      onChanged: (value) {
                                        setState(() => _selectedGender = value);
                                        state.didChange(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, top: 12),
                                  child: _buildErrorText(state.errorText!),
                                ),
                            ],
                          );
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Jenis kelamin harus dipilih' : null,
                      ),
                    ),
                  ),
                ]),

                const SizedBox(height: 24),

                // Pekerjaan
                _buildModernSection('Pekerjaan', Icons.work_outline, [
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return Column(
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _jobOptions.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var job = entry.value;
                                  return _buildAnimatedChoiceChip(
                                    job: job,
                                    isSelected: _selectedJob == job['value'],
                                    index: index,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedJob = selected ? job['value'] : null;
                                        state.didChange(_selectedJob);
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: _buildErrorText(state.errorText!),
                                ),
                            ],
                          );
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Pekerjaan harus dipilih' : null,
                      ),
                    ),
                  ),
                ]),

                const SizedBox(height: 24),

                // Tipe Pekerjaan
                _buildModernSection('Tipe Pekerjaan', Icons.business_center_outlined, [
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return Column(
                        children: [
                          ..._workTypeOptions.map((work) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildModernWorkTile(
                                  work: work,
                                  groupValue: _selectedWorkType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedWorkType = value;
                                      state.didChange(value);
                                    });
                                  },
                                ),
                              )),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: _buildErrorText(state.errorText!),
                            ),
                        ],
                      );
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Tipe pekerjaan harus dipilih' : null,
                  ),
                ]),

                const SizedBox(height: 32),

                // Tombol
                Row(
                  children: [
                    Expanded(
                      child: _buildGradientButton(
                        onPressed: _submitForm,
                        text: 'Simpan Data',
                        icon: Icons.save,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00695C), Color(0xFF00897B)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildOutlineButton(
                        onPressed: _resetForm,
                        text: 'Reset',
                        icon: Icons.refresh,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildModernSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF00897B)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF00897B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00897B), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildAnimatedGenderCard({
    required String title,
    required String value,
    required String? groupValue,
    required IconData icon,
    required Color color,
    required Gradient gradient,
    required void Function(String?) onChanged,
  }) {
    final isSelected = groupValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: isSelected ? gradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : color, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : color,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : color,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedChoiceChip({
    required Map<String, dynamic> job,
    required bool isSelected,
    required int index,
    required void Function(bool) onSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(job['icon'], size: 18, color: isSelected ? Colors.white : job['color']),
            const SizedBox(width: 8),
            Text(job['value']),
            if (isSelected && job['description'] != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job['description'],
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
        selected: isSelected,
        onSelected: onSelected,
        selectedColor: job['color'],
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: isSelected ? Colors.transparent : job['color'].withOpacity(0.3),
          ),
        ),
        elevation: isSelected ? 4 : 0,
        pressElevation: 2,
        shadowColor: job['color'].withOpacity(0.3),
      ),
    );
  }

  Widget _buildModernWorkTile({
    required Map<String, dynamic> work,
    required String? groupValue,
    required void Function(String?) onChanged,
  }) {
    final isSelected = groupValue == work['value'];
    final Color workColor = work['color'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected ? workColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? workColor : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: workColor.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: RadioListTile<String>(
        title: Text(
          work['value'],
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? workColor : Colors.grey[800],
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              work['subtitle'],
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? workColor.withOpacity(0.8) : Colors.grey[500],
              ),
            ),
            if (isSelected && work['benefits'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  children: (work['benefits'] as List<String>).map((benefit) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: workColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        benefit,
                        style: TextStyle(fontSize: 10, color: workColor, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
        value: work['value'],
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: workColor,
        secondary: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? workColor.withOpacity(0.15) : workColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(work['icon'], color: workColor, size: 26),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00695C).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlineButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF00897B), width: 2),
        foregroundColor: const Color(0xFF00897B),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildErrorText(String error) {
    return Row(
      children: [
        const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 14),
        const SizedBox(width: 6),
        Text(error, style: const TextStyle(color: Color(0xFFE53935), fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF00897B)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.check_circle, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pendaftaran Berhasil!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 12),
                _buildModernInfoRow(Icons.person, 'Nama Lengkap', _namaController.text),
                const SizedBox(height: 10),
                _buildModernInfoRow(Icons.cake, 'Umur', '${_umurController.text} tahun'),
                const SizedBox(height: 10),
                _buildModernInfoRow(Icons.people, 'Jenis Kelamin', _selectedGender!),
                const SizedBox(height: 10),
                _buildModernInfoRow(Icons.work, 'Pekerjaan', _selectedJob!),
                const SizedBox(height: 10),
                _buildModernInfoRow(Icons.business_center, 'Tipe Pekerjaan', _selectedWorkType!),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF00897B).withOpacity(0.1),
                foregroundColor: const Color(0xFF00897B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildModernInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF00897B).withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF00897B)),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF546E7A)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaController.clear();
    _umurController.clear();
    setState(() {
      _selectedGender = null;
      _selectedJob = null;
      _selectedWorkType = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Pendaftaran Berhasil!!', style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: const Color(0xFF00897B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}