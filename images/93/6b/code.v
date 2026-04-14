module top_module(
  input ctl,
  input vin,
  output iout
);parameter r = 100; // resistance value
parameter c = 1e-6; // capacitance value
parameter i = 1; // desired current value

reg v_filtered;
assign iout = v_filtered / r;

// Capacitor filter
reg [31:0] v_int;
always @(posedge ctl) begin
  v_int <= v_int + vin;
end

assign v_filtered = v_int >> 16;

endmodule