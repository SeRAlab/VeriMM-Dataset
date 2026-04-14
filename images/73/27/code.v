module top_module(clock, reset, enable, input_value, output_value);parameter WIDTH = 8;
  parameter DECREMENT_VALUE = 1;

  input clock, reset, enable;
  input [WIDTH-1:0] input_value;
  output [WIDTH-1:0] output_value;

  reg [WIDTH-1:0] counter_reg;

  always @(posedge clock) begin
    if (reset) begin
      counter_reg <= 0;
    end else if (enable) begin
      counter_reg <= input_value - DECREMENT_VALUE;
    end
  end

  assign output_value = counter_reg;

endmodule