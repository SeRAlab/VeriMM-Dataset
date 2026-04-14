module top_module(sum, overflow, A, B);output [31:0] sum;
  output overflow;
  input [31:0] A, B;
  
  wire [31:0] C;  // Carry bits
  wire [31:0] g;  // Generate signals
  wire [31:0] p;  // Propagate signals
  wire c31;       // Carry out bit
  wire [31:0] Cin;

  assign Cin = 32'b0; // Initial Carry In for the first bit

  // Generate the g and p signals for each bit
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : gen
      assign g[i] = A[i] & B[i];
      assign p[i] = A[i] | B[i];
    end
  endgenerate
  
  // Compute the carry bits
  assign C[0] = Cin[0];
  generate
    for (i = 0; i < 31; i = i + 1) begin : carry_gen
      assign C[i+1] = g[i] | (p[i] & C[i]);
    end
  endgenerate
  
  // Sum calculations
  generate
    for (i = 0; i < 32; i = i + 1) begin : sum_gen
      assign sum[i] = A[i] ^ B[i] ^ C[i];
    end
  endgenerate

  // Overflow determination
  assign overflow = C[31] ^ g[31]; // Overflow is true if the carry into the sign bit is different than the carry out

endmodule