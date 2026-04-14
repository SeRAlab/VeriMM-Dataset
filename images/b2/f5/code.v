module top_module(
    input s0,
    input s1,
    input i0,
    input i1,
    input i2,
    input i3,
    output reg d
    );always @(s0, s1, i0, i1, i2, i3) 
      begin
      if (s0 == 0 && s1 == 0) d = i0;
      else if (s0 == 0 && s1 == 1) d = i1;
      else if (s0 == 1 && s1 == 0) d = i2;
      else if (s0 == 1 && s1 == 1) d = i3;
      end
    
endmodule