module top_module(
    output O,
    input  I0
);parameter [1:0] INIT = 0;
  parameter EQN = "(I0)";

  
  specify
    (I0 => O) = 698;  
  endspecify

  assign O = I0 ? INIT[1] : INIT[0];
endmodule