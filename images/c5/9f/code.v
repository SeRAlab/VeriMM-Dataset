module bit_selector(
  input [3:0] in_signal,
  input control_signal,
  output reg [1:0] out_signal
);

  always @ (posedge control_signal) begin
    if(control_signal) begin
      out_signal <= ~in_signal[3:2];
    end
  end

endmodule