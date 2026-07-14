(module

  (func $collatz(param $num i32) (param $step i32) (result i32)
    (if (i32.lt_s (local.get $num) (i32.const 1))
      (then (return (i32.const -1)))
    )
    (if (i32.eq (local.get $num) (i32.const 1))
      (then (return (local.get $step)))
    )
    (local.set $step (i32.add (local.get $step) (i32.const 1)))
    (if (i32.and (local.get $num) (i32.const 1))
      (then 
        
        (local.set $num (i32.mul (local.get $num) (i32.const 3)))
        (local.set $num (i32.add (local.get $num) (i32.const 1)))
      )
     (else 
        (local.set $num (i32.div_u (local.get $num) (i32.const 2)))
      )
    )
    (return (call $collatz (local.get $num) (local.get $step)))
  )
  
  ;;
  ;; Return the number of steps needed to reach 1 in the Collatz conjecture.
  ;;
  ;; @param {i32} number - The number to start from.
  ;;
  ;; @returns {i32} - The number of steps needed to reach 1.
  ;;
  (func (export "steps") (param $number i32) (result i32)
    (local $step i32)
    (local.set $step (i32.const 0) )
    (local.set $step (call $collatz (local.get $number) (local.get $step)))
    (return (local.get $step))
  )
)