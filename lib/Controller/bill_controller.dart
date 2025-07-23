// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../Model/bill_model.dart';

// class BillController {
//   final _fs = FirebaseFirestore.instance;

//   Future<List<BillModel>> fetchBillsByUid(String uid) async {
//     final snaps = await _fs.collection('bills')
//       .where('uid', isEqualTo: uid)
//       .get();
//     return snaps.docs.map((d) => BillModel.fromFirestore(d.id, d.data())).toList();
//   }

//   Future<void> updateStatus(String billId, String newStatus) async {
//     await _fs.collection('bills').doc(billId).update({'status': newStatus});
//   }
// }
