module top_module(
  input clock, 
  input reset, 
  input [31:0] io_input_data, 
  input [31:0] io_input_init, 
  input io_input_enable, 
  input io_input_reset, 
  output reg [31:0] io_output_data
);always @(posedge clock or posedge reset) begin
    if (reset) begin
      io_output_data <= 0;
    end else if (io_input_reset) begin
      io_output_data <= io_input_init;
    end else if (io_input_enable) begin
      io_output_data <= io_input_data;
    end
  end

endmodule