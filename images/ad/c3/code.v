module top_module(
  input clk,
  input rst,
  input [31:0] input_signal,
  output reg [15:0] output_signal
);reg [31:0] sum;
  reg [3:0] count;

  always @(posedge clk) begin
    if (rst) begin
      sum <= 0;
      count <= 0;
      output_signal <= 0;
    end else begin
      sum <= sum + input_signal;
      count <= count + 1;
      if (count == 4) begin
        output_signal <= sum[29:16];
        sum <= sum - output_signal*4;
        count <= 0;
      end
    end
  end

endmodule