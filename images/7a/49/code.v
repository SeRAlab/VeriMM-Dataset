module top_module(clk, reset, IOA, IOB, IOE);input clk, reset;
  input [7:0] IOA, IOB;
  output reg [7:0] IOE;

  reg [3:0] mult_result;

  always @(posedge clk) begin
    if (reset) begin
      IOE <= 8'b0;
      mult_result <= 4'b0;
    end else begin
      mult_result <= (IOA & 4'b1111) * (IOB & 4'b1111);
      IOE[3:0] <= mult_result;
      IOE[7:4] <= 4'b0;
    end
  end

endmodule