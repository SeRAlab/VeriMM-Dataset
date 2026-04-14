module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    input load,       // Active-high parallel load input
    input [3:0] load_value, // 4-bit load value
    input a, 
    input b,
    output wire out,
    output [3:0] q // 4-bit output from the counter
);// Counter module
  reg [3:0] count;
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      count <= 4'b1000; // Asynchronous reset to 8
    end else if (load) begin
      count <= load_value;
    end else begin
      count <= count + 1;
    end
  end
  assign q = count;

  // AND gate made entirely out of NAND gates
  wire nand1, nand2, nand3;
  assign nand1 = ~(a & b);
  assign nand2 = ~(nand1 & nand1);
  assign nand3 = ~(nand2 & nand2);
  assign out = ~(nand3 & nand3);

endmodule