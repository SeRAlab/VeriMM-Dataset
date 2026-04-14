module top_module(
  input clk,
  input rst_n,
  input [7:0] rst_val,
  input en,
  output reg [7:0] gry_cnt,
  output reg [7:0] gry_cnt_nxt
);// Convert reset value to gray code
  reg [7:0] rst_gray;
  always @ (rst_val)
    rst_gray = rst_val ^ {1'b0, rst_val[7:1]};

  // Registers
  reg [7:0] bin_cnt_f;
  reg [7:0] bin_cnt_nxt;
  reg [7:0] gray_cnt_f;
  reg [7:0] gray_cnt_nxt_f;

  // Assign next binary count
  always @ (posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      bin_cnt_f <= rst_val;
      gray_cnt_f <= rst_gray;
    end
    else begin
      bin_cnt_f <= bin_cnt_nxt;
      gray_cnt_f <= gray_cnt_nxt_f;
    end
  end

  assign bin_cnt_nxt = bin_cnt_f + en;
  assign gray_cnt_nxt_f = bin_cnt_nxt ^ {1'b0, bin_cnt_nxt[7:1]};

  // Output
  always @ (posedge clk) begin
    gry_cnt <= gray_cnt_f;
    gry_cnt_nxt <= gray_cnt_nxt_f;
  end

endmodule