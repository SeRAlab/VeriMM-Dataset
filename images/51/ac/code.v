module top_module(
  input clk,
  input rst_n,
  input in_valid,
  input [15:0] in_a,
  input [15:0] in_b,
  input in_mode,
  output reg out_valid,  // Changed from wire to reg
  output reg [35:0] out
);always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      out <= 0;
      out_valid <= 0;
    end else begin
      if (in_valid) begin
        if (in_mode == 1) begin
          out <= {20'b0, in_a - in_b};
        end else begin
          out <= {20'b0, in_a + in_b};
        end
        out_valid <= 1;
      end else begin
        out_valid <= 0;
      end
    end
  end

endmodule