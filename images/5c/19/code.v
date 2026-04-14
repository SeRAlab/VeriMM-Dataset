module top_module(
  input        clock,
  input        reset,
  input  [1:0] io_input_0_data,
  input        io_input_0_reset,
  output [1:0] io_output_data
);reg [1:0] ff;
  
  always @(posedge clock or negedge reset) begin
    if (!reset) begin
      ff <= 2'h0;
    end else if (io_input_0_reset) begin
      ff <= ff;
    end else begin
      ff <= io_input_0_data;
    end
  end
  
  assign io_output_data = ff;
endmodule