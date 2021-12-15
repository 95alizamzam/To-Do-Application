import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/cubit/to_do_states.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';

class input_field extends StatelessWidget {
  const input_field({
    Key? key,
    required this.hint,
    required this.label,
    this.onchange,
    this.child,
    this.ontap,
  }) : super(key: key);

  final String label;
  final String hint;
  final Widget? child;
  final Function? ontap;
  final Function? onchange;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TODO_cubit, TODO_States>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = TODO_cubit.get(context);
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 6),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: cubit.tm == ThemeMode.dark
                          ? Colors.blue.shade300
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: cubit.tm == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            autofocus: false,
                            readOnly: child == null ? false : true,
                            decoration: InputDecoration(
                              hintText: hint,
                              hintStyle: TextStyle(
                                color: cubit.tm == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (String val) {
                              onchange!(val);
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ontap!();
                          },
                          child: child == null ? Container() : child,
                        ),
                      ],
                    )),
              ],
            ));
      },
    );
  }
}
