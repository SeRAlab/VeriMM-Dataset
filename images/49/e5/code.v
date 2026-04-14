module top_module(
  input i_clk,
  input [1:0] i_we,
  input [3:0] i_re,
  input [3:0] i_data_in_sel,
  input [15:0] i_data_out_sel,
  input [31:0] i_data_in,
  output reg [127:0] o_data_out
);reg [31:0] registers [15:0];

  always @(posedge i_clk) begin
    if (i_we[0]) registers[i_data_in_sel[1:0]] <= i_data_in;
    if (i_we[1]) registers[i_data_in_sel[3:2]] <= i_data_in;
    o_data_out[31:0] <= i_re[0] ? registers[i_data_out_sel[3:2]] : 32'h0;
    o_data_out[63:32] <= i_re[1] ? registers[i_data_out_sel[5:4]] : 32'h0;
    o_data_out[95:64] <= i_re[2] ? registers[i_data_out_sel[7:6]] : 32'h0;
    o_data_out[127:96] <= i_re[3] ? registers[i_data_out_sel[9:8]] : 32'h0;
  end

endmodule