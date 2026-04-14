module top_module(
  input [n-1:0] in,
  input clk,
  input rst,
  output [m-1:0] out
);parameter n = 16; // number of input samples
parameter m = 4; // number of output samples
parameter r = 4; // decimation rate
parameter N = 4; // filter order

// Internal signal for the count
reg [2:0] count; // 3 bits are enough for count (0 to 3)

// Define the integrator stage as a recursive function
function [n-1:0] integrator;
  input [n-1:0] in;
  input [N-1:0] stage;
  if (stage == 0) begin
    integrator = in;
  end else begin
    integrator = integrator(in + integrator, stage - 1);
  end
endfunction

// Define the comb stage as a recursive function
function [m-1:0] comb;
  input [n-1:0] in;
  input [n-1:0] delay;
  input [N-1:0] stage;
  if (stage == 0) begin
    comb = in;
  end else begin
    comb = comb(in - delay, comb, stage - 1);
  end
endfunction

// Connect the input samples to the integrator stages
wire [n-1:0] integrator_in;
assign integrator_in = in;
wire [n-1:0] integrator_out[N-1:0];
genvar i;
generate
  for (i = 0; i < N; i = i + 1) begin
    assign integrator_out[i] = integrator(integrator_in, i);
  end
endgenerate

// Connect the integrator stages to the comb stages
wire [n-1:0] comb_in;
assign comb_in = integrator_out[N-1];
wire [m-1:0] comb_out[N-1:0];
genvar j;
generate
  for (j = 0; j < N; j = j + 1) begin
    if (j == 0) begin
      assign comb_out[j] = comb(comb_in, {m{1'b0}}, j); // Initialize delay to zero for the first stage
    end else begin
      assign comb_out[j] = comb(comb_in, comb_out[j-1], j);
    end
  end
endgenerate

// Decimate the output samples by a factor of r
reg [m-1:0] out_reg;
always @(posedge clk or posedge rst) begin
  if (rst) begin
    out_reg <= {m{1'b0}}; // Reset output register
    count <= 0; // Reset count
  end else begin
    if (count == r - 1) begin
      out_reg <= comb_out[N-1];
      count <= 0; // Reset count after output
    end else begin
      count <= count + 1; // Increment count
    end
  end
end
assign out = out_reg;

endmodule