module top_module(input i1, input i2, output o2, output o1);wire _1_;
 assign o2 = i1 & i2;
 assign _1_ = i1 | i2;
 assign o1 = _1_ & o2;
endmodule