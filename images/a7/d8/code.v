module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);parameter DELAY = 1;

  reg a_dly;
  reg a_dly_dly;
  reg a_dly_dly_dly;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      a_dly <= 1'b0;
      a_dly_dly <= 1'b0;
      a_dly_dly_dly <= 1'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      a_dly <= a;
      a_dly_dly <= a_dly;
      a_dly_dly_dly <= a_dly_dly;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      if ((a_dly_dly_dly == 1'b0) && (a_dly_dly == 1'b0) && (a_dly == 1'b1)) begin
        rise <= 1'b1;
      end else begin
        rise <= 1'b0;
      end

      if ((a_dly_dly_dly == 1'b1) && (a_dly_dly == 1'b1) && (a_dly == 1'b0)) begin
        down <= 1'b1;
      end else begin
        down <= 1'b0;
      end
    end
  end

endmodule