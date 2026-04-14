module top_module(
  input [2:0] i_clks,
  input        i_clk0,
  input        i_clk1,
  input        i_clk2,
  input        i_data,

  output reg   o_data,   // Change wire to reg
  output reg   o_clk,    // Change wire to reg
  output reg   o_clk2,   // Change wire to reg
  output reg   o_clk3    // Change wire to reg
);reg [3:0] data_delay;
  reg [3:0] clk_cnt;
  reg [3:0] clk2_cnt;
  reg [3:0] clk3_cnt;

  always @(posedge i_clk0) begin
    data_delay <= {data_delay[2:0], i_data};
    o_data <= data_delay[3];
  end

  always @(posedge i_clk1) begin
    if (clk_cnt == 9) begin
      clk_cnt <= 0;
    end else begin
      clk_cnt <= clk_cnt + 1;
    end
    o_clk <= (clk_cnt < 5) ? 1'b1 : 1'b0;
  end

  always @(posedge i_clk2) begin
    if (clk2_cnt == 14) begin
      clk2_cnt <= 0;
    end else begin
      clk2_cnt <= clk2_cnt + 1;
    end
    o_clk2 <= (clk2_cnt < 7) ? 1'b1 : 1'b0;
  end

  always @(posedge i_clk0) begin
    if (clk3_cnt == 2) begin
      clk3_cnt <= 0;
    end else begin
      clk3_cnt <= clk3_cnt + 1;
    end
    o_clk3 <= (clk3_cnt == 0) ? 1'b1 : 1'b0;
  end

endmodule