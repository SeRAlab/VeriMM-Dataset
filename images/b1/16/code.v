module top_module(clk, rst, bin_in, gray_out, done);input clk, rst;
  input [7:0] bin_in;
  output [7:0] gray_out;
  output done;

  reg [7:0] gray_reg;
  reg done_reg;

  always @(posedge clk) begin
    if (rst) begin
      gray_reg <= 8'b0;
      done_reg <= 1'b0;
    end else begin
      gray_reg[0] <= bin_in[0];
      gray_reg[1] <= bin_in[0] ^ bin_in[1];
      gray_reg[2] <= bin_in[1] ^ bin_in[2];
      gray_reg[3] <= bin_in[2] ^ bin_in[3];
      gray_reg[4] <= bin_in[3] ^ bin_in[4];
      gray_reg[5] <= bin_in[4] ^ bin_in[5];
      gray_reg[6] <= bin_in[5] ^ bin_in[6];
      gray_reg[7] <= bin_in[6] ^ bin_in[7];
      done_reg <= 1'b1;
    end
  end

  assign gray_out = gray_reg;
  assign done = done_reg;

endmodule