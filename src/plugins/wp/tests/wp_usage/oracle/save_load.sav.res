[kernel] Parsing FRAMAC_SHARE/libc/__fc_builtin_for_normalization.i (no preprocessing)
[kernel] Parsing tests/wp_usage/save_load.i (no preprocessing)
[wp] Running WP plugin...
[wp] warning: Missing RTE guards
------------------------------------------------------------
  Function f
------------------------------------------------------------

Goal Post-condition (file tests/wp_usage/save_load.i, line 16) in 'f':
Assume {
  Type: is_sint32(a) /\ is_sint32(b) /\ is_sint32(b_1) /\ is_sint32(c) /\
      is_sint32(f) /\ is_sint32(f - b_1).
  If c != 0
  Then { Let x = 1 + a + b. Have: x = f. Have: x = f. }
  Else {
    Let x_1 = 1 + b_1.
    Have: (x_1 = b) /\ ((a + b_1) = f).
    Have: x_1 = b.
  }
}
Prove: 0 < (a + b).

------------------------------------------------------------
