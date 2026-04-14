module Mux_2to1(
   input                sel,
   input                in0,
   input                in1,
 
   output               out  
);
    assign out = sel ? in1 : in0;
endmodule