module top_module(
  input clk, // clock signal
  input [n-1:0] d, // data signal
  output reg [n-1:0] s // sum signal
);parameter n = 8; // number of bits in the accumulator register

reg [n-1:0] acc; // accumulator register

always @(posedge clk) begin
  acc <= acc + d; // add data signal to accumulator register
end

assign s = acc; // assign accumulator register to sum signal

endmodule