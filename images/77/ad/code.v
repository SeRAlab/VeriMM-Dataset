module top_module(
  input control,
  input [7:0] vref,
  output reg vout
);// The voltage reference signal is an 8-bit signal, which corresponds to a voltage range of 0-255.
// The output voltage is a continuous analog signal, which is approximated by a digital signal with a resolution of 8 bits.

  always @ (control, vref) begin
    if (control) begin
      vout <= vref;
    end else begin
      vout <= 0;
    end
  end
  
endmodule