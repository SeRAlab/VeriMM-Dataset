module top_module(
  input clk,
  input rst,
  output reg [w-1:0] rand_num
);parameter w = 8; // width of the random number

reg [w-1:0] lfsr_reg;
reg feedback;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    lfsr_reg <= 0;
  end else begin
    feedback = lfsr_reg[0] ^ lfsr_reg[1] ^ lfsr_reg[2] ^ lfsr_reg[3];
    lfsr_reg <= {feedback, lfsr_reg[w-2:1]};
  end
end

assign rand_num = lfsr_reg;

endmodule