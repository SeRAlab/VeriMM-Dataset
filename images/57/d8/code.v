module top_module(
  input [n-1:0] in,
  output par_out,
  output err
);parameter n = 8; // number of input signals

wire [n-1:0] in_and_par; // input and parity bit
wire [n-1:0] in_xor_par; // input xor parity bit
wire [n-1:0] in_count; // count of 1's in input
wire [n-1:0] par_count; // count of 1's in input plus parity bit

assign in_and_par = {in, par_out}; // concatenate input and parity bit
assign in_xor_par = in ^ par_out; // xor input and parity bit

// count number of 1's in input
genvar i;
generate
  for (i = 0; i < n; i = i + 1) begin : count_ones_input
    assign in_count[i] = in[i];
  end
endgenerate

// Initialize par_count to zero
assign par_count[0] = 1'b0;

// count number of 1's in input plus parity bit
generate
  for (i = 0; i < n; i = i + 1) begin : count_ones_parity
    assign par_count[0] = par_count[0] + in_xor_par[i];
  end
endgenerate

// generate parity bit
assign par_out = ~par_count[0];

// check parity
assign err = par_count[0] % 2;

endmodule