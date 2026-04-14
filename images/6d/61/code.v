module top_module(
  input signed [3:0] a,
  input signed [3:0] b,
  input clk,
  input reset,
  output reg signed [7:0] c
);wire signed [7:0] p;
  reg signed [7:0] ac;
  reg [3:0] count;
  reg done;

  assign p = {a, 4'b0} + ({~a[3], a[3:0]} << 4) + ({~b[3], b[3:0]} << 8);

  always @(posedge clk) begin
    if (reset) begin
      ac <= 8'b0;
      count <= 4'b0;
      done <= 1'b0;
      c <= 8'b0; // Reset output
    end else begin
      if (count == 4'b1000) begin
        done <= 1'b1;
        c <= ac; // Store the result when done
      end else begin
        if (p[0] == 1 && ac[7:0] < 0) begin
          ac <= ac + p;
        end else if (p[0] == 0 && ac[7:0] >= 0) begin
          ac <= ac - p;
        end
        ac <= ac >> 1;
        count <= count + 1;
      end
    end
  end

endmodule