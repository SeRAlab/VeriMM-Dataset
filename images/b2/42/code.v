module top_module(
  input Vin,
  output Iout
);parameter Iref = 1; // reference current value
parameter Rload = 10; // load resistance value

reg [31:0] Vout_reg; // output voltage register
reg [31:0] Iout_reg; // output current register

always @ (Vin, Vout_reg) begin
  Vout_reg = Vin * Rload; // calculate output voltage
  Iout_reg = Vout_reg / Iref; // calculate output current
end

assign Iout = Iout_reg; // assign output current

endmodule