module top_module(
  input [k-1:0] data_in,
  input [n-1:0] received,
  output [n-1:0] encoded,
  output [k-1:0] data_out
);parameter k = 4; // number of data bits
parameter n = 7; // number of encoded bits
parameter h = {{3'b001, 3'b011, 3'b010, 3'b100},
               {3'b101, 3'b111, 3'b110, 3'b000},
               {3'b111, 3'b101, 3'b100, 3'b010},
               {3'b011, 3'b001, 3'b000, 3'b110},
               {3'b110, 3'b100, 3'b101, 3'b011},
               {3'b010, 3'b000, 3'b001, 3'b111},
               {3'b000, 3'b010, 3'b011, 3'b101}}; // parity check matrix

wire [n-k-1:0] parity; // parity bits

// Encoder
genvar i;
generate
  for (i = 0; i < n-k; i = i + 1) begin : parity_gen
    assign parity[i] = data_in & h[i];
  end
endgenerate
assign encoded = {parity, data_in};

// Decoder
wire [n-k-1:0] syndrome;
wire [n-1:0] corrected;
genvar j;
generate
  for (j = 0; j < n-k; j = j + 1) begin : syndrome_gen
    assign syndrome[j] = received & h[j];
  end
endgenerate
assign corrected = received ^ {syndrome, {k{1'b0}}};
assign data_out = corrected[n-1:n-k];

endmodule