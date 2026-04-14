module top_module(
  input clk,
  input [n-1:0] in,
  input [n-1:0] I,
  input [n-1:0] Q,
  output [m-1:0] out
);parameter n = 8; // number of bits in the input signal
parameter m = 8; // number of bits in the output signal
parameter f_clk = 100; // frequency of the clock signal in MHz

reg [n-1:0] i_phase;
reg [n-1:0] q_phase;

always @(posedge clk) begin
  i_phase <= I;
  q_phase <= Q;
end

// Quadrature Demodulator
reg [n-1:0] demod_out;
reg [n-1:0] demod_in;
reg [n-1:0] demod_i;
reg [n-1:0] demod_q;

always @(posedge clk) begin
  demod_in <= in;
  demod_i <= i_phase;
  demod_q <= q_phase;
  
  demod_out <= (demod_in * demod_i) + (demod_in * demod_q);
end

// Quadrature Modulator
reg [n-1:0] mod_out;
reg [n-1:0] mod_in;
reg [n-1:0] mod_i;
reg [n-1:0] mod_q;

always @(posedge clk) begin
  mod_in <= out;
  mod_i <= i_phase;
  mod_q <= q_phase;
  
  mod_out <= (mod_in * mod_i) + (mod_in * mod_q);
end

endmodule