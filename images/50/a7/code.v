module top_module(
  input clk,
  input [7:0] ain,
  output reg [3:0] dout
);parameter n = 4; // number of bits in the digital output signal
  
  reg [7:0] sample;
  reg [n-1:0] quantized;
  
  always @(posedge clk) begin
    sample <= ain;
    quantized <= sample >> (8-n);
    dout <= quantized;
  end
  
endmodule