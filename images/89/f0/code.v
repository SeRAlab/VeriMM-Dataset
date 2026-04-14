module top_module(
  input clk,
  input reset,
  input enable,
  input mode,
  output reg [2:0] q
);always @(posedge clk or negedge reset) begin
    if (!reset) begin
      q <= 3'b0;
    end else if (enable) begin
      if (mode) begin
        // Down mode
        if (q == 3'b000) begin
          q <= 3'b111;
        end else begin
          q <= q - 1;
        end
      end else begin
        // Up mode
        if (q == 3'b111) begin
          q <= 3'b000;
        end else begin
          q <= q + 1;
        end
      end
    end
  end

endmodule