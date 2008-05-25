(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Export swap_spec_why.

(* Why obligation from file "/home/jcf/soft/why/examples-c/linked-lists/swap.c", line 12, characters 8-15: *)
(*Why goal*) Lemma swap_impl_po_1 : 
  forall (c: (pointer global)),
  forall (alloc: alloc_table),
  forall (tl_global: (memory (pointer global) global)),
  forall (HW_1: (* CADUCEUS_14 *)
                (exists l:plist, (llist tl_global alloc c l) /\
                 (list_length l) >= 2)),
  forall (HW_3: ~(c = (@null global))),
  forall (p: (pointer global)),
  forall (HW_4: p = c),
  (valid alloc c).
Proof.
(*unfold llist,lpath;*) intuition.
inversion_clear HW_1; intuition.
inversion H0; intuition.
Save.

(* Why obligation from file "/home/jcf/soft/why/examples-c/linked-lists/swap.c", line 13, characters 14-21: *)
(*Why goal*) Lemma swap_impl_po_2 : 
  forall (c: (pointer global)),
  forall (alloc: alloc_table),
  forall (tl_global: (memory (pointer global) global)),
  forall (HW_1: (* CADUCEUS_14 *)
                (exists l:plist, (llist tl_global alloc c l) /\
                 (list_length l) >= 2)),
  forall (HW_3: ~(c = (@null global))),
  forall (p: (pointer global)),
  forall (HW_4: p = c),
  forall (HW_5: (valid alloc c)),
  forall (result: (pointer global)),
  forall (HW_6: result = (acc tl_global c)),
  forall (mutable_c: (pointer global)),
  forall (HW_7: mutable_c = result),
  (valid alloc mutable_c).
Proof.
intuition; subst; auto.
inversion_clear HW_1; intuition.
inversion H0; subst; intuition.
inversion H3; subst; intuition.
elimtype False.
unfold list_length in H1.
simpl in H1.
auto.
Save.

(* Why obligation from file "/home/jcf/soft/why/examples-c/linked-lists/swap.c", line 13, characters 4-11: *)
(*Why goal*) Lemma swap_impl_po_3 : 
  forall (c: (pointer global)),
  forall (alloc: alloc_table),
  forall (tl_global: (memory (pointer global) global)),
  forall (HW_1: (* CADUCEUS_14 *)
                (exists l:plist, (llist tl_global alloc c l) /\
                 (list_length l) >= 2)),
  forall (HW_3: ~(c = (@null global))),
  forall (p: (pointer global)),
  forall (HW_4: p = c),
  forall (HW_5: (valid alloc c)),
  forall (result: (pointer global)),
  forall (HW_6: result = (acc tl_global c)),
  forall (mutable_c: (pointer global)),
  forall (HW_7: mutable_c = result),
  forall (HW_8: (valid alloc mutable_c)),
  forall (result0: (pointer global)),
  forall (HW_9: result0 = (acc tl_global mutable_c)),
  (valid alloc p).
Proof.
intuition.
subst; auto.
Save.

(* Why obligation from file "/home/jcf/soft/why/examples-c/linked-lists/swap.c", line 4, characters 12-145: *)
(*Why goal*) Lemma swap_impl_po_4 : 
  forall (c: (pointer global)),
  forall (alloc: alloc_table),
  forall (tl_global: (memory (pointer global) global)),
  forall (HW_1: (* CADUCEUS_14 *)
                (exists l:plist, (llist tl_global alloc c l) /\
                 (list_length l) >= 2)),
  forall (HW_3: ~(c = (@null global))),
  forall (p: (pointer global)),
  forall (HW_4: p = c),
  forall (HW_5: (valid alloc c)),
  forall (result: (pointer global)),
  forall (HW_6: result = (acc tl_global c)),
  forall (mutable_c: (pointer global)),
  forall (HW_7: mutable_c = result),
  forall (HW_8: (valid alloc mutable_c)),
  forall (result0: (pointer global)),
  forall (HW_9: result0 = (acc tl_global mutable_c)),
  forall (HW_10: (valid alloc p)),
  forall (tl_global0: (memory (pointer global) global)),
  forall (HW_11: tl_global0 = (upd tl_global p result0)),
  forall (HW_12: (valid alloc mutable_c)),
  forall (tl_global1: (memory (pointer global) global)),
  forall (HW_13: tl_global1 = (upd tl_global0 mutable_c p)),
  forall (caduceus_return: (pointer global)),
  forall (HW_14: caduceus_return = mutable_c),
  forall (l: plist),
  forall (c1: (pointer global)),
  forall (c2: (pointer global)),
  forall (HW_15: (llist tl_global alloc c (cons c1 (cons c2 l)))),
  (* CADUCEUS_15 *)
  (llist tl_global1 alloc caduceus_return (cons c2 (cons c1 l))).
Proof.
unfold cons ,llist, lpath; intuition; subst; auto.
inversion_clear HW_15.
assert (~ In c1 (c2::l)).
   apply llist_not_starting with (next := acc tl_global) (1:=H1).
assert (c1<>c2).
  red in H2; simpl in H2; auto.
assert (c2 = c1 # tl_global).
  inversion H1; auto.
subst.
inversion_clear H1.
apply Path_cons; auto.
caduceus.
apply Path_cons; auto.
caduceus.
apply lpath_pset_same; auto.
apply lpath_pset_same; auto.
intro; apply H2.
red; auto.
apply llist_not_starting with (next := acc tl_global) (1:=H6).
Save.

(* Why obligation from file "/home/jcf/soft/why/examples-c/linked-lists/swap.c", line 4, characters 12-145: *)
(*Why goal*) Lemma swap_impl_po_5 : 
  forall (c: (pointer global)),
  forall (alloc: alloc_table),
  forall (tl_global: (memory (pointer global) global)),
  forall (HW_1: (* CADUCEUS_14 *)
                (exists l:plist, (llist tl_global alloc c l) /\
                 (list_length l) >= 2)),
  forall (HW_16: c = (@null global)),
  forall (caduceus_return: (pointer global)),
  forall (HW_17: caduceus_return = c),
  forall (l: plist),
  forall (c1: (pointer global)),
  forall (c2: (pointer global)),
  forall (HW_18: (llist tl_global alloc c (cons c1 (cons c2 l)))),
  (* CADUCEUS_15 *)
  (llist tl_global alloc caduceus_return (cons c2 (cons c1 l))).
Proof.
intuition.
elimtype False.
clear HW_18 c2 c1.
inversion_clear HW_1.
inversion_clear H.
subst.
inversion H0; auto.
subst x.
auto.
Save.

