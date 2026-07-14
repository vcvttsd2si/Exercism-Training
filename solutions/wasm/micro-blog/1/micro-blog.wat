(module
  (memory (export "mem") 1)

  ;;
  ;; Truncate UTF-8 input string to 5 characters
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the truncated string in linear memory
  ;;
  (func (export "truncate") (param $offset i32) (param $length i32) (result i32 i32)
    (local $bytes_counted i32)
    (local $current_byte i32)
    (local $chars_counted i32)
    (local.set $bytes_counted (i32.const 0))
    (local.set $chars_counted (i32.const 0))
    (block $done
      (loop $loop
        (br_if $done (i32.eq (local.get $bytes_counted) (local.get $length)))
        (local.set $current_byte
          (i32.load8_u 
            (i32.add (local.get $offset) (local.get $bytes_counted))
          )
        )
        (if (
            i32.ne (i32.and (local.get $current_byte) (i32.const 0xC0)) (i32.const 0x80)
          )(then
              (br_if $done 
                (i32.eq (local.get $chars_counted) (i32.const 5))
              )
              (local.set $chars_counted 
                (i32.add (local.get $chars_counted) (i32.const 1))
              )
          )
        )
        (local.set $bytes_counted 
          (i32.add (local.get $bytes_counted) (i32.const 1))
        )
        (br $loop)
      )
    )
    (return (local.get $offset) (local.get $bytes_counted))
  )
)
