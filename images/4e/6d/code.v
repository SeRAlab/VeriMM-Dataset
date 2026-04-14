module top_module(
  input [n-1:0] data,
  input parity,
  output error
);parameter n = 4; // number of data signals

wire [n-1:0] xor_data; // intermediate signal for XOR of data signals

assign xor_data = ^data; // XOR of data signals

assign parity = ^data; // parity bit is the XOR of data signals

assign error = (parity == ^{data, parity}) ? 0 : 1; // check if parity bit matches XOR of data signals

endmodule