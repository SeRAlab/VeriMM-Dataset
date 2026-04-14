module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input samples per cycle
parameter m = 2; // number of output samples per cycle
parameter R = 4; // decimation or interpolation ratio
parameter N = 3; // order of the filter

wire [n*N-1:0] integrator_out; // Updated to allocate sufficient bits for integrators
wire [m*N-1:0] comb_out; // Updated to allocate sufficient bits for combs

// Integrator stage
genvar i;
generate
  for (i = 0; i < N; i = i + 1) begin : integrator_stage
    wire [n-1:0] integrator_in;
    wire [n-1:0] integrator_out_local;
    assign integrator_in = (i == 0) ? in : integrator_out[(i-1)*n +: n]; // +: syntax for part select
    assign integrator_out_local = (i == 0) ? integrator_in : integrator_out_local + integrator_out[(i-1)*n +: n];
    assign integrator_out[i*n +: n] = integrator_out_local; // Using +: syntax for part select
  end
endgenerate

// Comb stage
genvar j;
generate
  for (j = 0; j < N; j = j + 1) begin : comb_stage
    wire [m-1:0] comb_out_local;
    assign comb_out_local = (j == 0) ? integrator_out[N*n-m +: m] : comb_out_local + comb_out[(j-1)*m +: m];
    assign comb_out[j*m +: m] = comb_out_local; // Using +: syntax for part select
  end
endgenerate

assign out = comb_out;

endmodule