module top_module(
  output reg [3:0] count,
  input [2:0] index,
  input inc_dec_b,
  input enable,
  input rst,
  input clk
);reg [3:0] reg_cnt;
  reg [3:0] reg_cnt_next;
  reg [3:0] reg_cnt_next_next;
  reg [1:0] stage;
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      stage <= 0;
      reg_cnt <= 0;
      count <= 0;
    end else if (stage == 0) begin
      reg_cnt_next <= inc_dec_b ? reg_cnt + index : reg_cnt - index;
      stage <= 1;
    end else if (stage == 1) begin
      reg_cnt_next_next <= (reg_cnt_next == 4'hF && inc_dec_b) || (reg_cnt_next == 4'h0 && !inc_dec_b) ? reg_cnt_next_next : reg_cnt_next;
      stage <= 2;
    end else if (stage == 2) begin
      reg_cnt <= enable ? reg_cnt_next_next : 0;
      count <= reg_cnt;
      stage <= 0;
    end
  end
  
endmodule