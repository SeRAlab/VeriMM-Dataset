module top_module(
  input Vin,
  input Vref_high,
  input Vref_low,
  input Hysteresis,
  output reg Vout
);parameter Vdd = 1.8; // supply voltage
parameter Vss = 0; // ground voltage

always @ (Vin, Vout) begin
  if (Vin > Vref_high + Hysteresis/2) begin
    Vout <= Vdd;
  end else if (Vin < Vref_low - Hysteresis/2) begin
    Vout <= Vss;
  end
end

endmodule