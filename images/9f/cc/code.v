module top_module(
  input clk,
  input rst,
  input [7:0] release_time,
  output reg out
);reg [7:0] counter;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 0;
      out <= 0;
    end else begin
      if (counter == release_time) begin
        out <= 1;
      end else begin
        out <= 0;
      end
      counter <= counter + 1;
    end
  end

endmodule