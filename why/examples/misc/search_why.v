(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Import Why.


(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search1_po_1 : 
  forall (t: (array Z)),
  0 <= 0 /\ (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0)).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search1_po_2 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= 0 /\
                (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0))),
  forall (i: Z),
  forall (HW_2: 0 <= i /\
                (forall (k:Z), (0 <= k /\ k < i -> (access t k) <> 0))),
  forall (result: Z),
  forall (HW_3: result = (array_length t)),
  forall (HW_4: i < result),
  0 <= i /\ i < (array_length t).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search1_po_3 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= 0 /\
                (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0))),
  forall (i: Z),
  forall (HW_2: 0 <= i /\
                (forall (k:Z), (0 <= k /\ k < i -> (access t k) <> 0))),
  forall (result: Z),
  forall (HW_3: result = (array_length t)),
  forall (HW_4: i < result),
  forall (HW_5: 0 <= i /\ i < (array_length t)),
  forall (result0: Z),
  forall (HW_6: result0 = (access t i)),
  forall (HW_7: result0 = 0),
  (access t i) = 0.
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search1_po_4 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= 0 /\
                (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0))),
  forall (i: Z),
  forall (HW_2: 0 <= i /\
                (forall (k:Z), (0 <= k /\ k < i -> (access t k) <> 0))),
  forall (result: Z),
  forall (HW_3: result = (array_length t)),
  forall (HW_4: i < result),
  forall (HW_5: 0 <= i /\ i < (array_length t)),
  forall (result0: Z),
  forall (HW_6: result0 = (access t i)),
  forall (HW_8: result0 <> 0),
  forall (i0: Z),
  forall (HW_9: i0 = (i + 1)),
  (0 <= i0 /\ (forall (k:Z), (0 <= k /\ k < i0 -> (access t k) <> 0))) /\
  (Zwf 0 ((array_length t) - i0) ((array_length t) - i)).
Proof.
intuition.
assert (k=i \/ k<i). omega. 
intuition; subst; eauto. 
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search1_po_5 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= 0 /\
                (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0))),
  forall (i: Z),
  forall (HW_2: 0 <= i /\
                (forall (k:Z), (0 <= k /\ k < i -> (access t k) <> 0))),
  forall (result: Z),
  forall (HW_3: result = (array_length t)),
  forall (HW_10: i >= result),
  forall (k: Z),
  forall (HW_11: 0 <= k /\ k < (array_length t)),
  (access t k) <> 0.
Proof.
intuition.
subst.
apply H2 with k; auto with *.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search2_po_1 : 
  forall (t: (array Z)),
  0 <= 0 /\ (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0)).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search2_po_2 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= 0 /\
                (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0))),
  forall (i: Z),
  forall (HW_2: 0 <= i /\
                (forall (k:Z), (0 <= k /\ k < i -> (access t k) <> 0))),
  forall (result: Z),
  forall (HW_3: result = (array_length t)),
  forall (HW_4: i < result),
  0 <= i /\ i < (array_length t).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search2_po_3 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= 0 /\
                (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0))),
  forall (i: Z),
  forall (HW_2: 0 <= i /\
                (forall (k:Z), (0 <= k /\ k < i -> (access t k) <> 0))),
  forall (result: Z),
  forall (HW_3: result = (array_length t)),
  forall (HW_4: i < result),
  forall (HW_5: 0 <= i /\ i < (array_length t)),
  forall (result0: Z),
  forall (HW_6: result0 = (access t i)),
  forall (HW_7: result0 = 0),
  (access t i) = 0.
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search2_po_4 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= 0 /\
                (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0))),
  forall (i: Z),
  forall (HW_2: 0 <= i /\
                (forall (k:Z), (0 <= k /\ k < i -> (access t k) <> 0))),
  forall (result: Z),
  forall (HW_3: result = (array_length t)),
  forall (HW_4: i < result),
  forall (HW_5: 0 <= i /\ i < (array_length t)),
  forall (result0: Z),
  forall (HW_6: result0 = (access t i)),
  forall (HW_8: result0 <> 0),
  forall (i0: Z),
  forall (HW_9: i0 = (i + 1)),
  (0 <= i0 /\ (forall (k:Z), (0 <= k /\ k < i0 -> (access t k) <> 0))) /\
  (Zwf 0 ((array_length t) - i0) ((array_length t) - i)).
Proof.
intuition.
assert (k=i \/ k<i). omega.
intuition; subst; eauto.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search2_po_5 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= 0 /\
                (forall (k:Z), (0 <= k /\ k < 0 -> (access t k) <> 0))),
  forall (i: Z),
  forall (HW_2: 0 <= i /\
                (forall (k:Z), (0 <= k /\ k < i -> (access t k) <> 0))),
  forall (result: Z),
  forall (HW_3: result = (array_length t)),
  forall (HW_10: i >= result),
  forall (k: Z),
  forall (HW_11: 0 <= k /\ k < (array_length t)),
  (access t k) <> 0.
Proof.
intuition.
subst.
apply H2 with k; auto with *.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search3_po_1 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= (array_length t)),
  0 <= 0 /\ 0 <= (array_length t).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search3_po_2 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= (array_length t)),
  forall (HW_2: 0 <= 0 /\ 0 <= (array_length t)),
  forall (HW_4: (forall (k:Z),
                 (0 <= k /\ k < (array_length t) -> (access t k) <> 0))),
  forall (k: Z),
  forall (HW_5: 0 <= k /\ k < (array_length t)),
  (access t k) <> 0.
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search3_po_3 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= (array_length t)),
  forall (i: Z),
  forall (t0: (array Z)),
  forall (HW_6: 0 <= i /\ i <= (array_length t0)),
  forall (result: Z),
  forall (HW_7: result = (array_length t0)),
  forall (HW_8: i = result),
  forall (k: Z),
  forall (HW_9: i <= k /\ k < (array_length t0)),
  (access t0 k) <> 0.
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search3_po_4 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= (array_length t)),
  forall (i: Z),
  forall (t0: (array Z)),
  forall (HW_6: 0 <= i /\ i <= (array_length t0)),
  forall (result: Z),
  forall (HW_7: result = (array_length t0)),
  forall (HW_10: i <> result),
  0 <= i /\ i < (array_length t0).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search3_po_5 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= (array_length t)),
  forall (i: Z),
  forall (t0: (array Z)),
  forall (HW_6: 0 <= i /\ i <= (array_length t0)),
  forall (result: Z),
  forall (HW_7: result = (array_length t0)),
  forall (HW_10: i <> result),
  forall (HW_11: 0 <= i /\ i < (array_length t0)),
  forall (result0: Z),
  forall (HW_12: result0 = (access t0 i)),
  forall (HW_13: result0 = 0),
  (access t0 i) = 0.
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search3_po_6 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= (array_length t)),
  forall (i: Z),
  forall (t0: (array Z)),
  forall (HW_6: 0 <= i /\ i <= (array_length t0)),
  forall (result: Z),
  forall (HW_7: result = (array_length t0)),
  forall (HW_10: i <> result),
  forall (HW_11: 0 <= i /\ i < (array_length t0)),
  forall (result0: Z),
  forall (HW_12: result0 = (access t0 i)),
  forall (HW_14: result0 <> 0),
  (Zwf 0 ((array_length t0) - (i + 1)) ((array_length t0) - i)).
Proof.
intuition.
assert( k=i \/ i+1<=k). omega.
intuition; subst; auto with *.
eauto.
Save.
(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search3_po_7 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= (array_length t)),
  forall (i: Z),
  forall (t0: (array Z)),
  forall (HW_6: 0 <= i /\ i <= (array_length t0)),
  forall (result: Z),
  forall (HW_7: result = (array_length t0)),
  forall (HW_10: i <> result),
  forall (HW_11: 0 <= i /\ i < (array_length t0)),
  forall (result0: Z),
  forall (HW_12: result0 = (access t0 i)),
  forall (HW_14: result0 <> 0),
  forall (HW_15: (Zwf 0 ((array_length t0) - (i + 1)) ((array_length t0) - i))),
  0 <= (i + 1) /\ (i + 1) <= (array_length t0).
Proof.
(* FILL PROOF HERE *)
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma search3_po_8 : 
  forall (t: (array Z)),
  forall (HW_1: 0 <= (array_length t)),
  forall (i: Z),
  forall (t0: (array Z)),
  forall (HW_6: 0 <= i /\ i <= (array_length t0)),
  forall (result: Z),
  forall (HW_7: result = (array_length t0)),
  forall (HW_10: i <> result),
  forall (HW_11: 0 <= i /\ i < (array_length t0)),
  forall (result0: Z),
  forall (HW_12: result0 = (access t0 i)),
  forall (HW_14: result0 <> 0),
  forall (HW_15: (Zwf 0 ((array_length t0) - (i + 1)) ((array_length t0) - i))),
  forall (HW_16: 0 <= (i + 1) /\ (i + 1) <= (array_length t0)),
  forall (HW_18: (forall (k:Z),
                  ((i + 1) <= k /\ k < (array_length t0) -> (access t0 k) <>
                   0))),
  forall (k: Z),
  forall (HW_19: i <= k /\ k < (array_length t0)),
  (access t0 k) <> 0.
Proof.
(* FILL PROOF HERE *)
Save.

