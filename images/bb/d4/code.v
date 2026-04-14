module top_module(clk, reset, input_bus_1, input_bus_2, output_bus);input clk;
  input reset;
  input [31:0] input_bus_1, input_bus_2;
  output reg [31:0] output_bus;
  
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      output_bus <= 32'b0;
    end else begin
      output_bus <= input_bus_1 | input_bus_2;
    end
  end
endmodule