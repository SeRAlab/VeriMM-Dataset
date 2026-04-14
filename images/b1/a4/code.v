module top_module(
  input [31:0] A,
  input [31:0] B,
  input clk,
  input rst,
  output reg [63:0] C
);// Stage 1: Generate partial products
  reg [31:0] pp1 [0:31];
  integer i;
  always @ (posedge clk) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        pp1[i] <= 0;
      end
    end else begin
      for (i = 0; i < 32; i = i + 1) begin
        pp1[i] <= A * (B[i]);
      end
    end
  end

  // Stage 2: Add partial products
  reg [63:0] pp2 [0:31];
  always @ (posedge clk) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        pp2[i] <= 0;
      end
    end else begin
      for (i = 0; i < 31; i = i + 2) begin
        pp2[i+1] <= pp1[i][31:0] + pp1[i+1][31:0];
        pp2[i] <= {pp1[i][31:0], pp1[i+1][31:0]} + pp2[i+1][31:0];
      end
    end
  end

  // Stage 3: Shift and add partial products
  always @ (posedge clk) begin
    if (rst) begin
      C <= 0;
    end else begin
      C <= {pp2[31][63:32], pp2[31][31:0], pp2[30][63:32], pp2[30][31:0], pp2[29][63:32], pp2[29][31:0], pp2[28][63:32], pp2[28][31:0], pp2[27][63:32], pp2[27][31:0], pp2[26][63:32], pp2[26][31:0], pp2[25][63:32], pp2[25][31:0], pp2[24][63:32], pp2[24][31:0], pp2[23][63:32], pp2[23][31:0], pp2[22][63:32], pp2[22][31:0], pp2[21][63:32], pp2[21][31:0], pp2[20][63:32], pp2[20][31:0], pp2[19][63:32], pp2[19][31:0], pp2[18][63:32], pp2[18][31:0], pp2[17][63:32], pp2[17][31:0], pp2[16][63:32], pp2[16][31:0], pp2[15][63:32], pp2[15][31:0], pp2[14][63:32], pp2[14][31:0], pp2[13][63:32], pp2[13][31:0], pp2[12][63:32], pp2[12][31:0], pp2[11][63:32], pp2[11][31:0], pp2[10][63:32], pp2[10][31:0], pp2[9][63:32], pp2[9][31:0], pp2[8][63:32], pp2[8][31:0], pp2[7][63:32], pp2[7][31:0], pp2[6][63:32], pp2[6][31:0], pp2[5][63:32], pp2[5][31:0], pp2[4][63:32], pp2[4][31:0], pp2[3][63:32], pp2[3][31:0], pp2[2][63:32], pp2[2][31:0], pp2[1][63:32], pp2[1][31:0], pp2[0][63:32], pp2[0][31:0]};
    end
  end

endmodule