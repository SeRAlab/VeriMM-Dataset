module top_module(O, I0, I1, I2, I3, S0, S1);output O;
  input I0, I1, I2, I3, S0, S1;
  wire T0, T1;
  parameter _TECHMAP_BITS_CONNMAP_ = 0;
  parameter [_TECHMAP_BITS_CONNMAP_-1:0] _TECHMAP_CONNMAP_I0_ = 0;
  parameter [_TECHMAP_BITS_CONNMAP_-1:0] _TECHMAP_CONNMAP_I1_ = 0;
  parameter [_TECHMAP_BITS_CONNMAP_-1:0] _TECHMAP_CONNMAP_I2_ = 0;
  parameter [_TECHMAP_BITS_CONNMAP_-1:0] _TECHMAP_CONNMAP_I3_ = 0;
  parameter _TECHMAP_CONSTMSK_S0_ = 0;
  parameter _TECHMAP_CONSTVAL_S0_ = 0;
  parameter _TECHMAP_CONSTMSK_S1_ = 0;
  parameter _TECHMAP_CONSTVAL_S1_ = 0;
  if (_TECHMAP_CONSTMSK_S0_ && _TECHMAP_CONSTVAL_S0_ === 1'b1)
    assign T0 = I1;
  else if (_TECHMAP_CONSTMSK_S0_ || _TECHMAP_CONNMAP_I0_ === _TECHMAP_CONNMAP_I1_)
    assign T0 = I0;
  else
    MUXF7 mux7a (.I0(I0), .I1(I1), .S(S0), .O(T0));
  if (_TECHMAP_CONSTMSK_S0_ && _TECHMAP_CONSTVAL_S0_ === 1'b1)
    assign T1 = I3;
  else if (_TECHMAP_CONSTMSK_S0_ || _TECHMAP_CONNMAP_I2_ === _TECHMAP_CONNMAP_I3_)
    assign T1 = I2;
  else
    MUXF7 mux7b (.I0(I2), .I1(I3), .S(S0), .O(T1));
  if (_TECHMAP_CONSTMSK_S1_ && _TECHMAP_CONSTVAL_S1_ === 1'b1)
    assign O = T1;
  else if (_TECHMAP_CONSTMSK_S1_ || (_TECHMAP_CONNMAP_I0_ === _TECHMAP_CONNMAP_I1_ && _TECHMAP_CONNMAP_I1_ === _TECHMAP_CONNMAP_I2_ && _TECHMAP_CONNMAP_I2_ === _TECHMAP_CONNMAP_I3_))
    assign O = T0;
  else
    MUXF8 mux8 (.I0(T0), .I1(T1), .S(S1), .O(O));
endmodule