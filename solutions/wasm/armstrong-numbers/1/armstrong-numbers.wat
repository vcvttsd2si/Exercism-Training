(module
  ;; base ** exp => (for i=0; i<exp; i++) base * base
  (func $pow (param $base i32) (param $exp i32) (result i32)
    (local $res i32)  
    (local.set $res (i32.const 1)) ;; res = 1
    (block $done
      (loop $loop
        ;; exp == 0 => break
        (br_if $done (i32.eqz (local.get $exp))) 
        ;; res = res * base
        (local.set $res (i32.mul (local.get $res) (local.get $base)))
        ;; exp = exp - 1
        (local.set $exp (i32.sub (local.get $exp) (i32.const 1)))

        (br $loop)
      )
    )
    (local.get $res) ;; return res
  )
  
  ;; 
  ;; Determine if a number is an Armstrong number.
  ;;
  ;; @param {i32} candidate - The number to check.
  ;;
  ;; @return {i32} 1 if the number is an Armstrong number, 0 otherwise.
  ;;
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    (local $temp i32)
    (local $numDigits i32)
    (local $digit i32)
    (local $sum i32)
    
    (if (i32.eqz (local.get $candidate))
      (then (return (i32.const 1)))
    )

    ;; Count number of digits
    (local.set $temp (local.get $candidate))
    (local.set $numDigits (i32.const 0))
    (block $counted
      (loop $loop_digits
        ;; numDigits = numDigits + 1
        (local.set $numDigits (i32.add (local.get $numDigits) (i32.const 1)))
        ;; temp = temp / 10
        (local.set $temp (i32.div_u (local.get $temp) (i32.const 10)))
        ;; check temp > 0
        (br_if $loop_digits (i32.gt_u (local.get $temp) (i32.const 0)))
      )
    )
    
    ;; Sum over the powers
    (local.set $sum (i32.const 0))
    (local.set $temp (local.get $candidate))
    (block $done
      (loop $extract_and_sum
        ;; extract digit
        (local.set $digit (i32.rem_u (local.get $temp) (i32.const 10)))
        ;; call pow and add result
        (local.set $sum (i32.add (call $pow (local.get $digit) (local.get $numDigits)) (local.get $sum)))
        ;; temp = temp / 10
        (local.set $temp (i32.div_u (local.get $temp) (i32.const 10)))
        ;; check temp > 0
        (br_if $extract_and_sum (i32.gt_u (local.get $temp) (i32.const 0)))
      )
    )

    ;; sum == candidate ?
    (i32.eq (local.get $candidate) (local.get $sum)) ;; temp return
  )
)
