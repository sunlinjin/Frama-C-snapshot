typedef int foo[4];

foo X = {0,1,2,3};

/*@ predicate p1(foo a) = \valid_range(a,0,3); */

/*@ predicate q1(foo a) = \valid(a + (0..3)); */

/*@ lemma tauto: \forall foo a; p1(a) <==> q1(a); */

/*@ lemma tauto1{L}: q1(X); */

/*@ requires p1(x); */
int f1(foo x) { return x[3]; }

int g1() { return f1(X); }
