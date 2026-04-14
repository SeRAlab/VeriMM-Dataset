module top_module(
  input clk,
  input reset,
  output reg [2:0] count_gray
);reg [2:0] count_bin;

  always @(posedge clk) begin
    if (reset) begin
      count_bin <= 3'b000;
      count_gray <= 3'b000;
    end
    else begin
      count_bin <= count_bin + 1;
      count_gray <= {count_bin[2], count_bin[2]^count_bin[1], count_bin[1]^count_bin[0]};
    end
  end

endmodule