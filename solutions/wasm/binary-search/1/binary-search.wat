(module
  (memory (export "mem") 1)
 
  ;;
  ;; Find the first occurrence of the needle in the haystack
  ;;
  ;; @param {i32} base - the base address of the haystack
  ;; @param {i32} nelems - the number of elements in the haystack
  ;; @param {i32} needle - the value to search for
  ;;
  ;; @return {i32} the index of the first occurrence of the needle in the haystack
  ;;               or -1 if the needle is not found.
  ;;
  (func (export "find") (param $base i32) (param $nelems i32) (param $needle i32) (result i32)
    (local $low i32)
    (local $mid i32)
    (local $high i32)
    (local $tempv i32)
    (if (i32.eqz (local.get $nelems))
      (then
        (return (i32.const -1))
      )
    )
    (local.set $tempv (i32.load (local.get $base)))
    (if (i32.gt_u (local.get $tempv) (local.get $needle))
      (then
        (return (i32.const -1))
      )
    )
    (local.set $low (i32.const 0))
    (local.set $high (i32.sub (local.get $nelems) (i32.const 1)))
    (local.set $tempv
      (i32.load
        (i32.add (local.get $base) (i32.shl (local.get $high) (i32.const 2)))
      )
    )
    (if (i32.lt_u (local.get $tempv) (local.get $needle))
      (then
        (return (i32.const -1))
      )
    )
    (block $notFound
      (loop $loop
        (br_if $notFound (i32.gt_u (local.get $low) (local.get $high)))
        (local.set $mid (i32.add (local.get $low) (local.get $high)))
        (local.set $mid (i32.div_u (local.get $mid) (i32.const 2)))
        (local.set $tempv
          (i32.load 
            (i32.add (local.get $base) (i32.shl (local.get $mid) (i32.const 2)))
          )
        )
        (if (i32.eq (local.get $tempv) (local.get $needle))
          (then
            (return (local.get $mid))
          )
        )
        (if (i32.lt_u (local.get $tempv) (local.get $needle))
          (then
            (local.set $low (i32.add (local.get $mid) (i32.const 1)))
          )(else
            (local.set $high (i32.sub (local.get $mid) (i32.const 1)))
          )
        )
        (br $loop)
      )
    )
    (i32.const -1)
  )
)
