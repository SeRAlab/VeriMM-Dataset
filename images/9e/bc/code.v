module top_module(
  input in,
  input clk,
  input rst,
  output out
);parameter n = 8; // number of flip-flops in the shift register

reg [n-1:0] shift_reg; // declare shift register as a vector of n flip-flops

always @(posedge clk) begin
  if (rst) begin
    shift_reg <= 0; // reset all flip-flops to 0
  end else begin
    shift_reg <= {in, shift_reg[n-1:1]}; // shift input into first flip-flop and shift data through chain
  end
end

assign out = shift_reg[n-1]; // output value stored in last flip-flop

endmodule