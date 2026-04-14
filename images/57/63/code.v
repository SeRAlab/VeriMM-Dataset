module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  output [2*n-1:0] P
);parameter n = 8; // size of input numbers
parameter p = 4; // number of pipeline stages

reg [n-1:0] a_reg [0:p-1]; // pipeline registers for A
reg [n-1:0] b_reg [0:p-1]; // pipeline registers for B
reg [2*n-1:0] p_reg [0:p-1]; // pipeline registers for partial products

wire [n-1:0] a_partial [0:p-1]; // partial A for each pipeline stage
wire [n-1:0] b_partial [0:p-1]; // partial B for each pipeline stage
wire [2*n-1:0] p_partial [0:p-1]; // partial product for each pipeline stage

// generate partial A and B for each pipeline stage
genvar i;
generate
  for (i = 0; i < p; i = i + 1) begin : partial_gen
    assign a_partial[i] = A[(i+1)*n-1:i*n];
    assign b_partial[i] = B[(i+1)*n-1:i*n];
  end
endgenerate

// generate partial products for each pipeline stage
genvar j;
generate
  for (j = 0; j < p; j = j + 1) begin : mult_gen
    assign p_partial[j] = a_partial[j] * b_partial[j];
  end
endgenerate

// connect pipeline stages
integer k;
always @(*) begin
  a_reg[0] = A;
  b_reg[0] = B;
  p_reg[0] = p_partial[0];
  for (k = 1; k < p; k = k + 1) begin
    a_reg[k] = a_reg[k-1];
    b_reg[k] = b_reg[k-1];
    p_reg[k] = p_reg[k-1] + p_partial[k];
  end
end

// output final product
assign P = p_reg[p-1];

endmodule