module top_module(
  input [7:0] A,
  input [7:0] B,
  output reg [15:0] C
);always @(*) begin
    C = {A, B << 8};
  end
  
endmodule