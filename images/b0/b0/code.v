module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out // Changed from wire to reg
);parameter n = 16; // number of input samples
parameter m = 4; // number of output samples
parameter R = 4; // decimation factor
parameter M = 3; // number of stages
parameter N = 4; // samples per stage

reg [n-1:0] delay_line [0:M-1][0:N-1]; // Changed to match input width
reg [n-1:0] comb_delay_line [0:M-1][0:N-1]; // Changed to match input width

integer i, j;

always @(*) begin
  // Initialize delay lines to zero
  for (i = 0; i < M; i = i + 1) begin
    for (j = 0; j < N; j = j + 1) begin
      delay_line[i][j] = 0;
      comb_delay_line[i][j] = 0;
    end
  end

  // Integrator stage
  for (i = 0; i < M; i = i + 1) begin
    delay_line[i][0] = in; // Changed to use entire input
    for (j = 1; j < N; j = j + 1) begin
      delay_line[i][j] = delay_line[i][j-1] + (i > 0 ? delay_line[i-1][j-1] : 0); // Prevention of out of range access
    end
  end
  
  // Comb stage
  for (i = 0; i < M; i = i + 1) begin
    comb_delay_line[i][0] = delay_line[i][N-1];
    for (j = 1; j < N; j = j + 1) begin
      comb_delay_line[i][j] = comb_delay_line[i][j-1] - (i > 0 ? comb_delay_line[i-1][j-1] : 0); // Prevention of out of range access
    end
  end
  
  // Decimation stage
  for (i = 0; i < m; i = i + 1) begin
    out[i] = comb_delay_line[M-1][i*R]; // R is the decimation factor
  end
end

endmodule