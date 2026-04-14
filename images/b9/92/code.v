module top_module(
  input Vin_p,
  input Vin_n,
  output Vout
);parameter Vth_p = 1; // upper threshold voltage
parameter Vth_n = 0; // lower threshold voltage
parameter Vref = 2; // reference voltage
parameter Vdd = 5; // supply voltage

reg Vout_reg;
wire Vin_p_above_Vth_p;
wire Vin_n_below_Vth_n;

assign Vin_p_above_Vth_p = Vin_p > Vth_p;
assign Vin_n_below_Vth_n = Vin_n < Vth_n;

always @ (Vin_p or Vin_n or Vout_reg) begin
  if (Vin_p_above_Vth_p) begin
    Vout_reg <= 1'b1;
  end else if (Vin_n_below_Vth_n) begin
    Vout_reg <= 1'b0;
  end
end

assign Vout = Vout_reg;

endmodule