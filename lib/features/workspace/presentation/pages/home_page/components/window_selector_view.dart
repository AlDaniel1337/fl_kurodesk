import 'package:material_ui/material_ui.dart';
import 'package:kurodesk/features/workspace/domain/entities/window_info.dart';

class WindowSelectorView extends StatelessWidget {
  final String groupName;
  final List<WindowInfo> availableWindows;
  final Set<int> selectedHwnds;
  final ValueChanged<WindowInfo> onToggleWindow;
  final VoidCallback onRefresh;
  final VoidCallback onDone;

  const WindowSelectorView({
    super.key,
    required this.groupName,
    required this.availableWindows,
    required this.selectedHwnds,
    required this.onToggleWindow,
    required this.onRefresh,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Ventanas · $groupName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 17, color: Colors.white70),
                  onPressed: onRefresh,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: availableWindows.length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final win = availableWindows[index];
                  final isChecked = selectedHwnds.contains(win.hwnd);

                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onToggleWindow(win),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isChecked ? const Color(0xFF222222) : const Color(0xFF151515),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isChecked ? Colors.white54 : const Color(0xFF262626),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: win.isMinimized ? Colors.white24 : Colors.greenAccent,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      win.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      '${win.processName} · ${win.isMinimized ? "Minimizada" : "En monitor"}',
                                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                                size: 16,
                                color: isChecked ? Colors.white : Colors.white30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF262626),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onDone,
                child: const Text('Listo', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}