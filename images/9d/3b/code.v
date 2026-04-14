module top_module(
  input [n-1:0] in,
  input rst,
  input en,
  output reg [15:0] out
);parameter n = 8; // number of input signals
parameter m = 1; // number of output signals

// additional parameters for the Adler checksum algorithm
parameter A_INIT = 1;
parameter B_INIT = 0;
parameter MODULO = 65521;
parameter CHUNK_SIZE = 8; 

// internal signals and variables
reg [7:0] data_chunk;
reg [15:0] a_reg, b_reg;
reg [15:0] checksum_reg;
wire valid;

// implementation of Adler checksum generator and checker
always @ (posedge en) begin
  if (rst) begin
    a_reg <= A_INIT;
    b_reg <= B_INIT;
    checksum_reg <= 0;
  end else begin
    data_chunk <= {in};
    a_reg <= (a_reg + data_chunk) % MODULO;
    b_reg <= (b_reg + a_reg) % MODULO;
    checksum_reg <= {a_reg, b_reg};
  end
end

assign valid = (checksum_reg == out);

endmodule