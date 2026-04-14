module top_module(
  input clk,
  input reset,
  input mode,
  output reg [2:0] q,
  output reg max_reached,  // Changed to reg
  output reg min_reached    // Changed to reg
);always @(posedge clk) begin
    if (reset) begin
      q <= 3'b000;
      max_reached <= 1'b0;
      min_reached <= 1'b0;
    end
    else begin
      if (mode) begin
        if (q == 3'b111) begin
          max_reached <= 1'b1;
          q <= 3'b000;
        end
        else begin
          max_reached <= 1'b0;
          q <= q + 1;
        end
      end
      else begin
        if (q == 3'b000) begin
          min_reached <= 1'b1;
          q <= 3'b111;
        end
        else begin
          min_reached <= 1'b0;
          q <= q - 1;
        end
      end
    end
  end

endmodule