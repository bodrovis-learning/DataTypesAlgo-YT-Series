# frozen_string_literal: true

require 'ffi'

module ModPow
  extend FFI::Library

  ffi_lib File.expand_path('./modpow.dll', __dir__)
  attach_function :ModPow, %i[ulong_long ulong_long ulong_long], :ulong_long
end
