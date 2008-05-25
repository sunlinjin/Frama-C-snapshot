/* run.config
   OPT: -simplify-cfg -keep-switch -print -files-debug -check
   OPT: -simplify-cfg -print -files-debug -check
*/

void f() {
  int i = 0;
  //@ loop invariant 0 <= i <= 10;
  while (i < 10) { // @ invariant 0 <= i < 10;
    ++i;
    //@ assert 0 <= i <= 10;
  }
}
