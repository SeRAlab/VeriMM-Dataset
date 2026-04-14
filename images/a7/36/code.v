module top_module(
  input clk,
  input rst,
  input signed [15:0] in_val,
  input signed [15:0] min_val,
  input signed [15:0] max_val,
  output reg signed [15:0] out_round,
  output reg signed [15:0] out_sat
);always @(posedge clk) begin
    if (rst) begin
      out_round <= 0;
      out_sat <= 0;
    end
    else begin
      // Round block
      if (in_val[0]) begin
        out_round <= in_val + 1;
      end
      else begin
        out_round <= in_val;
      end
      
      // Saturation block
      if (in_val < min_val) begin
        out_sat <= min_val;
      end
      else if (in_val > max_val) begin
        out_sat <= max_val;
      end
      else begin
        out_sat <= in_val;
      end
    end
  end

endmodule