module top_module(
    output O,
    input  I0,
    I1
);parameter [3:0] INIT = 4'h0;
  parameter EQN = "(I0)";

  
  specify
    (I0 => O) = 1251;  
    (I1 => O) = 1406;  
  endspecify

  wire [1:0] s1 = I1 ? INIT[3:2] : INIT[1:0];
  assign O = I0 ? s1[1] : s1[0];
endmodule