module top_module(
  input [n-1:0] in,
  input parity_type_in,
  output p,
  output out
);parameter n = 4; // number of input signals

wire [n-1:0] in_count;
wire parity_count;
wire parity_check;

assign in_count = {in[0], in[1], in[2], in[3]}; // count the number of input signals that are logic high
assign parity_count = ^in_count; // generate the parity bit based on the parity type

assign p = parity_count; // assign the generated parity bit to the output signal

// compare the generated parity bit with the input parity bit to determine whether the parity is correct or incorrect
assign parity_check = (parity_type_in == 0) ? (parity_count == 0) : (parity_count == 1);

assign out = parity_check; // assign the output signal to indicate whether the parity is correct or incorrect

endmodule