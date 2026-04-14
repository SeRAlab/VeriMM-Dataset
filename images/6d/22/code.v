module top_module(
  input wire clk,
  input wire reset,
  input wire [1:0] ctrl,
  input wire [3:0] in,
  output reg [2:0] out
);parameter const_val = 3;

  always @(posedge clk) begin
    if (reset) begin
      out <= 0;
    end else begin
      if (ctrl == 2'b00) begin
        out <= in;
      end else begin
        if (in + const_val >= 7) begin
          out <= 7;
        end else if (in + const_val <= 0) begin
          out <= 0;
        end else begin
          out <= in + const_val;
        end
      end
    end
  end

endmodule