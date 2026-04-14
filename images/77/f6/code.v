module top_module(
  input Vin,
  input Vref,
  output Iout
);parameter I = 1; // desired constant current
parameter R = 10; // resistance value of the load

assign Iout = (Vref - Vin) / R * I;

endmodule