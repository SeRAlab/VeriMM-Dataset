module top_module(
    input [7:0] in,
    output [7:0] out
);// Example behavior for bt module (you can adjust according to your design)
   assign out = ~in; // Inverts the input bits
   
endmodule