module top_module(
  input data,
  input clk,
  input reset,
  output shifted_data
);parameter n = 8; // number of flip-flops in the shift register

reg [n-1:0] shift_reg; // define the shift register as an array of n flip-flops

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0; // reset all flip-flops to 0
  end else begin
    shift_reg <= {data, shift_reg[n-1:1]}; // shift data into first flip-flop, shift all other bits to the right
  end
end

assign shifted_data = shift_reg[n-1]; // output the last bit in the shift register

endmodule