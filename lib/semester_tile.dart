import 'package:flutter/material.dart';

import 'package:semester/semester_file.dart';

class MySemesterTile extends StatelessWidget {
  final Semester semt;
  final Function update, delete;

  const MySemesterTile({required this.semt, required this.update, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(color: Colors.red,),
      onDismissed: (direction) {
        delete(semt.t_id);
        ScaffoldMessenger.of(context).
        showSnackBar(SnackBar(content: const
        Text('Semester has been removed'), backgroundColor: Colors.grey[800],));
      },
      key: UniqueKey(),
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.green.shade700,
                width: 1.5
            )
        ),
        child: ListTile(
          trailing: IconButton(icon: const Icon(Icons.edit),
            iconSize: 20,
            onPressed: () => update(semt),
          ),

          title: Text(
            semt.t_name.toString(), style: const TextStyle(fontSize: 20),),
          subtitle: Text('Time : ${semt.time.hour}:${semt.time.minute} \n'
              'Date: ${semt.time.day}/ ${semt.time.month}/'
              ' ${semt.time.year} ',

            style: const TextStyle(fontSize: 17),),
        ),
      ),
    );
  }
}


