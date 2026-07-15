(module
  (func $max (param $m1 i32) (param $m2 i32) (result i32)
    (if (i32.lt_u (local.get $m1) (local.get $m2))
      (then
        (return (local.get $m2))
      )
    )
    (return (local.get $m1))
  )
  (func $gcd (param $m1 i32) (param $m2 i32) (result i32)
    (if (i32.eqz (local.get $m2))
      (then 
        (return (local.get $m1))
      )
    )
    (call $gcd
      (local.get $m2) (i32.rem_u (local.get $m1) (local.get $m2))
    )
  )
  
  ;;
  ;; Get to the goal using two buckets
  ;;
  ;; @param {i32} $bucketOne - capacity of the first bucket
  ;; @param {i32} $bucketTwo - capacity of the second bucket
  ;; @param {i32} $goal - level to achieve by filling / emptying the buckets
  ;; @param {i32} $starterBucket - bucket to start with (1 / 2)
  ;;
  ;; @returns {(i32,i32,i32)} number of moves, winning bucket, level of other bucket;
  ;;                          if unsolvable, make sure moves is -1
  ;;
  (func (export "twoBucket") (param $bucketOne i32) (param $bucketTwo i32)
  (param $goal i32) (param $starterBucket i32) (result i32 i32 i32)
    (local $maxBucket i32)
    (local $state1 i32)
    (local $state2 i32)
    (local $moves i32)
    (local $tempv i32)
    (local.set $maxBucket 
      (call $max (local.get $bucketOne) (local.get $bucketTwo))
    )
    (if (i32.gt_u (local.get $goal) (local.get $maxBucket))
      (then
        (return (i32.const -1) (i32.const 0) (i32.const 0))
      )
    )
    (if (i32.rem_u (local.get $goal) (call $gcd (local.get $bucketOne) (local.get $bucketTwo)))
      (then
        (return (i32.const -1) (i32.const 0) (i32.const 0))
      )
    )
    (if (i32.eq (local.get $starterBucket) (i32.const 1))
      (then
        (local.set $state1 (local.get $bucketOne))
        (local.set $state2 (i32.const 0))
      )
      (else
        (local.set $state1 (i32.const 0))
        (local.set $state2 (local.get $bucketTwo))
      )
    )
    (local.set $moves (i32.const 1))
    (block $done
      (loop $loop
        (if (i32.eq (local.get $goal) (local.get $state1))
          (then
            (return (local.get $moves) (i32.const 1) (local.get $state2))
          )
        )
        (if (i32.eq (local.get $goal) (local.get $state2))
          (then
            (return (local.get $moves) (i32.const 2)(local.get $state1))
          )
        )
        ;; if moves == 1 && MaxCapacity(Destination) == goal then shortcut
        (if (i32.eq (local.get $moves) (i32.const 1))
          (then
            (if (i32.eq (local.get $starterBucket) (i32.const 1))
              (then
                (if (i32.eq (local.get $bucketTwo) (local.get $goal))
                  (then
                    (local.set $state2 (local.get $bucketTwo))
                    (local.set $moves (i32.add (local.get $moves) (i32.const 1)))
                    (br $loop)
                  )
                )
              )(else
                (if (i32.eq (local.get $bucketOne) (local.get $goal))
                  (then
                    (local.set $state1 (local.get $bucketOne))
                    (local.set $moves (i32.add (local.get $moves) (i32.const 1)))
                    (br $loop)
                  )
                )
              )
            )
          )
        )
        ;; Sink -> Bucket1 (Source) -> Bucket2 (Destination) -> Hole
        (if (i32.eq (local.get $starterBucket) (i32.const 1))
          (then
            (if (i32.eqz (local.get $state1))
              (then
                (local.set $state1 (local.get $bucketOne)) ;; if Bucket1 == 0 then fill(Bucket1)
              )(else
                (if (i32.eq (local.get $state2) (local.get $bucketTwo))
                  (then
                    (local.set $state2 (i32.const 0)) ;; if Destination is full then empty(Destination)
                  )(else
                    ;; Available Space in Bucket2 := (MaxCapacity(Bucket2) - CurrentCapacity(Bucket2))
                    (local.set $tempv (i32.sub (local.get $bucketTwo) (local.get $state2)))
                    ;; if CurrentCapacity(Bucket1) < Available Space then pour it 
                    (if (i32.lt_u (local.get $state1) (local.get $tempv))
                      (then
                        (local.set $tempv (local.get $state1))
                      )
                    )
                    ;; state1 -> 0
                    (local.set $state1 (i32.sub (local.get $state1) (local.get $tempv)))
                    ;; state2 += CurrentCapacity(Bucket1)
                    (local.set $state2 (i32.add (local.get $state2) (local.get $tempv)))
                  )
                )
              )
            )
          )(else
            (if (i32.eqz (local.get $state2))
              (then
                (local.set $state2 (local.get $bucketTwo))
              )(else
                (if (i32.eq (local.get $state1) (local.get $bucketOne))
                  (then
                    (local.set $state1 (i32.const 0))
                  )(else
                    (local.set $tempv (i32.sub (local.get $bucketOne) (local.get $state1)))
                    (if (i32.lt_u (local.get $state2) (local.get $tempv))
                      (then
                        (local.set $tempv (local.get $state2))
                      )
                    )
                    (local.set $state2 (i32.sub (local.get $state2) (local.get $tempv)))
                    (local.set $state1 (i32.add (local.get $state1) (local.get $tempv)))
                  )
                )
              )          
            )
          )
        )
        (local.set $moves (i32.add (local.get $moves) (i32.const 1)))
        (br $loop)
      )    
    )
    (i32.const -1) (i32.const 0) (i32.const 0)
  )
)
