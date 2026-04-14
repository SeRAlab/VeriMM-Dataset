module top_module(
  input [15:0] num_in,
  output reg [63:0] num_out
);reg [47:0] sign_bits; // 48 replicated sign bits
  
  // replicate sign bit
  always @(*) begin
    sign_bits = {48{num_in[15]}};
  end
  
  // concatenate sign bits with num_in
  always @(*) begin
    num_out = {sign_bits, num_in};
  end
  
endmodule