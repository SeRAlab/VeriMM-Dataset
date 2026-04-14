module top_module(
  input clk,
  input reset,
  input input_signal,
  output output_signal
);reg d_ff;

  always @(posedge clk) begin
    if(reset) begin
      d_ff <= 1'b0;
    end else begin
      d_ff <= input_signal;
    end
  end

  assign output_signal = ~d_ff;

endmodule