import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_state.dart';

class HydrationModal extends StatefulWidget {
  final AppState state;

  const HydrationModal({super.key, required this.state});

  @override
  State<HydrationModal> createState() => _HydrationModalState();
}

class _HydrationModalState extends State<HydrationModal> {
  final TextEditingController _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _addAmount(int ml) {
    if (ml <= 0) return;
    widget.state.addWater(ml);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.state.todayHydrationTotal;
    final goal = widget.state.dynamicHydrationGoal;
    final progress = (total / goal).clamp(0.0, 1.0);
    final entries = widget.state.hydrationEntries;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop_rounded, color: AppTheme.primaryBlue, size: 24),
                SizedBox(width: 8),
                Text(
                  "Hydration Tracker",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Goal adjusted dynamically for ${widget.state.profile.lifestyle.name} & Heat Index (${widget.state.environment.heatIndex.toStringAsFixed(1)}°C)",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),

            // Progress Ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: AppTheme.surfaceSubtle,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "$total",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      "/ $goal ml",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick add buttons (+100 ml, +250 ml, +500 ml)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuickButton("+100 ml", 100),
                const SizedBox(width: 10),
                _buildQuickButton("+250 ml", 250),
                const SizedBox(width: 10),
                _buildQuickButton("+500 ml", 500),
              ],
            ),
            const SizedBox(height: 16),

            // Custom amount field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Custom amount (ml)",
                      hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final val = int.tryParse(_customController.text.trim());
                    if (val != null && val > 0) {
                      _addAmount(val);
                      _customController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Today's log with undo/delete
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Hydration Log",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "No water logged yet today. Stay hydrated!",
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, idx) {
                    final item = entries[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.water_drop, size: 16, color: AppTheme.accentCyan),
                              const SizedBox(width: 8),
                              Text(
                                "${item.amountMl} ml",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.dangerRed),
                            onPressed: () {
                              widget.state.removeWater(item.id);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, int amount) {
    return InkWell(
      onTap: () => _addAmount(amount),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primaryLightBlue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
      ),
    );
  }
}

