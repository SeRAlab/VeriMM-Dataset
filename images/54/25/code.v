module top_module(
  input clk,
  input reset,
  input enable,
  output reg [3:0] lfsr_out
);reg [3:0] lfsr_reg;

always @(posedge clk) begin
  if (reset) begin
    lfsr_reg <= 4'b0001;
  end else if (enable) begin
    lfsr_reg <= {lfsr_reg[2:0], lfsr_reg[3] ^ lfsr_reg[0]};
  end
end

assign lfsr_out = lfsr_reg;

endmodule