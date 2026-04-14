module top_module(
  input wire clk,
  input wire [15:0] reset,
  input wire [15:0] load,
  input wire [15:0] count_in,
  output reg [15:0] count_out,
  output reg overflow
);always @(*) begin
    if (load) begin
      count_out <= count_in;
      overflow <= 0;
    end else if (count_out == 16'hFFFF) begin
      count_out <= 0;
      overflow <= 1;
    end else begin
      count_out <= count_out + 1;
      overflow <= 0;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      count_out <= 0;
      overflow <= 0;
    end
  end

endmodule