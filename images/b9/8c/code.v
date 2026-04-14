module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out,
  input mode,
  input clk,
  input reset
);parameter n = 8; // number of input signals
parameter m = 8; // number of output signals
parameter k = 4; // maximum number of consecutive repetitions that can be encoded.

reg [n-1:0] input_reg;
reg [m-1:0] output_reg;
reg [k:0] count_reg; // Changed to k:0 to accommodate counting from 0 to k
reg [n-1:0] value_reg;
reg encoding_mode;

always @(posedge clk) begin
  if (reset) begin
    input_reg <= 0;
    output_reg <= 0;
    count_reg <= 0;
    value_reg <= 0;
    encoding_mode <= 1'b0;
  end else begin
    if (mode) begin // decoding mode
      if (count_reg == 0) begin
        value_reg <= in;
        count_reg <= 1;
      end else if (count_reg == k) begin
        output_reg <= value_reg;
        count_reg <= 0;
      end else if (in == value_reg) begin
        count_reg <= count_reg + 1;
      end else begin
        output_reg <= value_reg;
        value_reg <= in;
        count_reg <= 1;
      end
    end else begin // encoding mode
      if (count_reg == 0) begin
        value_reg <= in;
        count_reg <= 1;
      end else if (count_reg == k) begin
        output_reg <= {value_reg, count_reg};
        count_reg <= 1;
        value_reg <= in;
      end else if (in == value_reg) begin
        count_reg <= count_reg + 1;
      end else begin
        output_reg <= {value_reg, count_reg};
        value_reg <= in;
        count_reg <= 1;
      end
    end
    out <= output_reg;
    input_reg <= in;
    encoding_mode <= mode;
  end
end

endmodule