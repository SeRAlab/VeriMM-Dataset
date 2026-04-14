module top_module(
  input [7:0] bus_in,
  input clk,
  input reset,
  output [7:0] bus_out
);reg [7:0] stored_value;

  always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      stored_value <= 8'b0;
    end else begin
      stored_value <= bus_in;
    end
  end

  assign bus_out = stored_value;

endmodule