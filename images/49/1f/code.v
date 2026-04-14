module top_module(
  input clk_i,
  input clk_en,
  input rst_i,
  input prbs_seed_init,
  input [31:0] prbs_seed_i,
  output [31:0] prbs_o
);reg [31:0] lfsr_q;
reg [31:0] prbs;

always @(posedge clk_i) begin
  if (rst_i || (prbs_seed_init && !clk_en)) begin
    lfsr_q <= prbs_seed_i;
  end else if (clk_en) begin
    lfsr_q[31:0] <= {lfsr_q[30:0], lfsr_q[0] ^ lfsr_q[21] ^ lfsr_q[31] ^ lfsr_q[22]};
  end
end

assign prbs_o = lfsr_q;

endmodule