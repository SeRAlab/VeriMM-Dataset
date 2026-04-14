module top_module(
  input        clock,
  input        reset,
  input  [7:0] io_input_0_data,
  input        io_input_0_enable,
  input        io_input_0_reset,
  output [7:0] io_output_data
);reg [7:0] ff;

  always @(posedge clock) begin
    if (reset) begin
      ff <= 8'h0;
    end else begin
      if (io_input_0_reset) begin
        ff <= 8'h0;
      end else begin
        if (io_input_0_enable) begin
          ff <= io_input_0_data;
        end
      end
    end
  end
  
  assign io_output_data = ff;
  
endmodule