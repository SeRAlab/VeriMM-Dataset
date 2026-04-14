module top_module(
  output reg clk,
  output reg en
);parameter n = 5; // number of inverters in the ring oscillator

reg [n-1:0] inv_out; // output of each inverter in the ring

// define the inverters and connect them in a ring
genvar i;
generate
  for (i = 0; i < n; i = i + 1) begin : INV
    assign inv_out[i] = ~inv_out[(i+1)%n];
  end
endgenerate

// generate the clock signal from the output of the last inverter
always @(inv_out[n-1]) begin
  clk <= inv_out[n-1];
end

// generate the enable signal based on the stability of the clock signal
always @(posedge clk) begin
  en <= ~en;
end

endmodule