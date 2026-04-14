module top_module(
  input        clk,
  input        reset,
  input  [15:0] input_signal,
  output [3:0] output_signal
);reg [3:0] output_reg;

  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      output_reg <= 4'b0;
    end else begin
      output_reg <= input_signal[15:12];
    end
  end

  assign output_signal = output_reg;

endmodule