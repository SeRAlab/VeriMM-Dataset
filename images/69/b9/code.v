module top_module(
  input clk,
  input reset,
  input load,
  input [2:0] data,
  output reg [2:0] gray_code
);reg [2:0] counter;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      counter <= 3'b000;
      gray_code <= 3'b000;
    end else if (load) begin
      counter <= data;
      gray_code <= data ^ (data >> 1);
    end else begin
      counter <= counter + 1;
      gray_code <= counter ^ (counter >> 1);
    end
  end

endmodule