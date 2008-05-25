(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Export Why.


(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_1 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_3: m < n),
  forall (a0: (array Z)),
  forall (i: Z),
  forall (j: Z),
  forall (HW_4: m <= j /\ j < i /\ i <= n /\ (sub_permut m n a a0) /\
                (exists x:Z,
                 (forall (r:Z), (m <= r /\ r <= j -> (access a0 r) <= x)) /\
                 (forall (r:Z), (j < r /\ r < i -> (access a0 r) = x)) /\
                 (forall (r:Z), (i <= r /\ r <= n -> (access a0 r) >= x)))),
  0 <= (n - m).
Proof.
Admitted.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_2 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_3: m < n),
  forall (a0: (array Z)),
  forall (i: Z),
  forall (j: Z),
  forall (HW_4: m <= j /\ j < i /\ i <= n /\ (sub_permut m n a a0) /\
                (exists x:Z,
                 (forall (r:Z), (m <= r /\ r <= j -> (access a0 r) <= x)) /\
                 (forall (r:Z), (j < r /\ r < i -> (access a0 r) = x)) /\
                 (forall (r:Z), (i <= r /\ r <= n -> (access a0 r) >= x)))),
  (j - m) < (n - m).
Proof.
Admitted.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_3 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_3: m < n),
  forall (a0: (array Z)),
  forall (i: Z),
  forall (j: Z),
  forall (HW_4: m <= j /\ j < i /\ i <= n /\ (sub_permut m n a a0) /\
                (exists x:Z,
                 (forall (r:Z), (m <= r /\ r <= j -> (access a0 r) <= x)) /\
                 (forall (r:Z), (j < r /\ r < i -> (access a0 r) = x)) /\
                 (forall (r:Z), (i <= r /\ r <= n -> (access a0 r) >= x)))),
  forall (HW_5: (Zwf 0 (j - m) (n - m))),
  forall (HW_6: m <= j),
  forall (a1: (array Z)),
  forall (HW_7: (sub_permut m j a0 a1) /\ (sorted_array a1 m j)),
  0 <= (n - m).
Proof.
Admitted.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_4 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_3: m < n),
  forall (a0: (array Z)),
  forall (i: Z),
  forall (j: Z),
  forall (HW_4: m <= j /\ j < i /\ i <= n /\ (sub_permut m n a a0) /\
                (exists x:Z,
                 (forall (r:Z), (m <= r /\ r <= j -> (access a0 r) <= x)) /\
                 (forall (r:Z), (j < r /\ r < i -> (access a0 r) = x)) /\
                 (forall (r:Z), (i <= r /\ r <= n -> (access a0 r) >= x)))),
  forall (HW_5: (Zwf 0 (j - m) (n - m))),
  forall (HW_6: m <= j),
  forall (a1: (array Z)),
  forall (HW_7: (sub_permut m j a0 a1) /\ (sorted_array a1 m j)),
  (n - i) < (n - m).
Proof.
Admitted.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_5 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_3: m < n),
  forall (a0: (array Z)),
  forall (i: Z),
  forall (j: Z),
  forall (HW_4: m <= j /\ j < i /\ i <= n /\ (sub_permut m n a a0) /\
                (exists x:Z,
                 (forall (r:Z), (m <= r /\ r <= j -> (access a0 r) <= x)) /\
                 (forall (r:Z), (j < r /\ r < i -> (access a0 r) = x)) /\
                 (forall (r:Z), (i <= r /\ r <= n -> (access a0 r) >= x)))),
  forall (HW_5: (Zwf 0 (j - m) (n - m))),
  forall (HW_6: m <= j),
  forall (a1: (array Z)),
  forall (HW_7: (sub_permut m j a0 a1) /\ (sorted_array a1 m j)),
  forall (HW_8: (Zwf 0 (n - i) (n - m))),
  i <= n.
Proof.
Admitted.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_6 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_3: m < n),
  forall (a0: (array Z)),
  forall (i: Z),
  forall (j: Z),
  forall (HW_4: m <= j /\ j < i /\ i <= n /\ (sub_permut m n a a0) /\
                (exists x:Z,
                 (forall (r:Z), (m <= r /\ r <= j -> (access a0 r) <= x)) /\
                 (forall (r:Z), (j < r /\ r < i -> (access a0 r) = x)) /\
                 (forall (r:Z), (i <= r /\ r <= n -> (access a0 r) >= x)))),
  forall (HW_5: (Zwf 0 (j - m) (n - m))),
  forall (HW_6: m <= j),
  forall (a1: (array Z)),
  forall (HW_7: (sub_permut m j a0 a1) /\ (sorted_array a1 m j)),
  forall (HW_8: (Zwf 0 (n - i) (n - m))),
  forall (HW_9: i <= n),
  forall (a2: (array Z)),
  forall (HW_10: (sub_permut i n a1 a2) /\ (sorted_array a2 i n)),
  (sub_permut m n a a2).
Proof.
Admitted.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_7 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_3: m < n),
  forall (a0: (array Z)),
  forall (i: Z),
  forall (j: Z),
  forall (HW_4: m <= j /\ j < i /\ i <= n /\ (sub_permut m n a a0) /\
                (exists x:Z,
                 (forall (r:Z), (m <= r /\ r <= j -> (access a0 r) <= x)) /\
                 (forall (r:Z), (j < r /\ r < i -> (access a0 r) = x)) /\
                 (forall (r:Z), (i <= r /\ r <= n -> (access a0 r) >= x)))),
  forall (HW_5: (Zwf 0 (j - m) (n - m))),
  forall (HW_6: m <= j),
  forall (a1: (array Z)),
  forall (HW_7: (sub_permut m j a0 a1) /\ (sorted_array a1 m j)),
  forall (HW_8: (Zwf 0 (n - i) (n - m))),
  forall (HW_9: i <= n),
  forall (a2: (array Z)),
  forall (HW_10: (sub_permut i n a1 a2) /\ (sorted_array a2 i n)),
  (sorted_array a2 m n).
Proof.
intuition.
unfold sorted_array.
simplify.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_8 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_11: m >= n),
  (sub_permut m n a a).
Proof.
intuition.
(* FILL PROOF HERE *)
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma quicksort_po_9 : 
  forall (m: Z),
  forall (n: Z),
  forall (a: (array Z)),
  forall (HW_1: m <= n),
  forall (HW_11: m >= n),
  (sorted_array a m n).
Proof.
intuition.
(* FILL PROOF HERE *)
Save.

