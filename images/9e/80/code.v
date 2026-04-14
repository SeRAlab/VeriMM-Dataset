module top_module(
  output out
);parameter n = 5; // number of NOT gates in the ring oscillator (must be odd)
parameter r = 100; // resistance of the resistor used in the relaxation oscillator
parameter c = 0.1; // capacitance of the capacitor used in the relaxation oscillator
parameter vdd = 5; // supply voltage of the circuit

// no inputs required for this circuit

// define loop of NOT gates
wire [n-1:0] not_out;
assign not_out[0] = ~not_out[n-1];
generate
  genvar i;
  for (i = 1; i < n; i = i + 1) begin
    assign not_out[i] = ~not_out[i-1];
  end
endgenerate

// define relaxation oscillator
wire clk;
reg [31:0] count;
reg [31:0] charge;
assign clk = not_out[n-1];
always @(posedge clk) begin
  if (count == 0) begin
    charge = 0;
  end else if (count == 500) begin
    charge = 1;
  end
  count <= count + 1;
end

// output waveform
assign out = charge;

endmodule