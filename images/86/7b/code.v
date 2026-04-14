module top_module(
  input               clk,
  input               rst_n,
  input               A,
  output reg          rise,
  output reg          down
);reg prev_A;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      prev_A <= 1'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end
    else begin
      if (A != prev_A) begin
        if (A == 1'b1) begin
          rise <= 1'b1;
          down <= 1'b0;
        end
        else begin
          rise <= 1'b0;
          down <= 1'b1;
        end
      end
      else begin
        rise <= 1'b0;
        down <= 1'b0;
      end
      prev_A <= A;
    end
  end

endmodule