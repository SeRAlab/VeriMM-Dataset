module top_module(
  input in,
  input [1:0] sel,     // Select signal, adjusted to accommodate for n=4
  output [3:0] out     // Output size defined according to n=4
);// Define the number of outputs
parameter n = 4;

// Drive output signals based on the select signal
assign out = (sel == 2'b00) ? {3'b000, in} :
             (sel == 2'b01) ? {2'b00, in, 1'b0} :
             (sel == 2'b10) ? {1'b0, in, 2'b00} :
             (sel == 2'b11) ? {in, 3'b000} : 4'b0000; // Default case (should be unreachable)

endmodule