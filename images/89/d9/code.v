module top_module(
  input clk,
  input reset,
  input [3:0] a,
  input [3:0] b,
  input op,
  output [3:0] result,
  output overflow
);reg [4:0] temp_sum;
  reg [4:0] temp_diff;
  
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      temp_sum <= 0;
      temp_diff <= 0;
    end else begin
      case (op)
        0: temp_sum <= a + b;
        1: temp_diff <= a - b;
      endcase
    end
  end
  
  assign result = (op == 0) ? temp_sum[3:0] : temp_diff[3:0];
  assign overflow = (op == 0) ? (temp_sum > 15) : (temp_diff < 0);
  
endmodule