module top_module(
  input clk,
  input reset,
  input enable,
  input control,
  input select,
  input [7:0] data_in,
  output reg [7:0] q
);reg [3:0] counter;
  wire [7:0] mux_out;

  // 4-bit counter with asynchronous reset and enable input
  always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      counter <= 0;
    end else if (enable) begin
      counter <= counter + 1;
    end
  end

  // Multiplexer that selects between the output of the counter and a constant value based on a control input
  assign mux_out = control ? 8'hFF : counter;

  // 2-to-1 multiplexer that selects between the output of the previous multiplexer and an 8-bit input data based on a select input
  always @(*) begin
    if (select) begin
      q <= data_in;
    end else begin
      q <= mux_out;
    end
  end

endmodule