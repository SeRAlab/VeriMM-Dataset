module top_module(
  input clk,
  input rst,
  input start,
  output reg [n-1:0] rand_num
);parameter n = 8; // width of the random number

reg [n-1:0] lfsr_reg;
reg feedback;

always @ (posedge clk) begin
  if (rst) begin
    lfsr_reg <= 0;
  end
  else if (start) begin
    feedback = lfsr_reg[0] ^ lfsr_reg[1] ^ lfsr_reg[3] ^ lfsr_reg[4];
    lfsr_reg <= {lfsr_reg[n-2:0], feedback};
  end
end

assign rand_num = lfsr_reg;

endmodule