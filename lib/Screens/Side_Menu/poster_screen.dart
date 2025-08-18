import 'package:extend_my_pay_admin_panel/Provider/poster_provider.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PosterScreen extends StatelessWidget {
  const PosterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosterProvider>(
      builder: (context, prov, _) {
        if (prov.posters.isEmpty) {
          prov.loadPosters();
        }

        return AdminLayout(
          screenTitle: "Manage Posters",
          child: Padding(
            padding: EdgeInsets.all(20.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(height: 40.h), // Adds space at top
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF941A),
                        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 4,
                      ),
                      onPressed: prov.isLoading ? null : () => prov.upload(),
                      icon: const Icon(Icons.upload, color: Colors.white),
                      label: Text(
                        prov.isLoading ? "Uploading..." : "Upload Poster",
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: prov.posters.isEmpty
                      ? Center(
                          child: Text(
                            "No posters uploaded yet.",
                            style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 4 : 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                          ),
                          itemCount: prov.posters.length,
                          itemBuilder: (context, i) {
                            final p = prov.posters[i];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 6,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      p.imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: const Color(0xFFFF941A),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 8.h,
                                    right: 8.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () => prov.delete(p.id),
                                      ),
                                    ),
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
      },
    );
  }
}
