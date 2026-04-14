module top_module(a, clk, spo);input [7:0] a;
  input clk;
  output reg [91:0] spo; // Changed from wire to reg

  reg [31:0] mem[255:0];

  always @(posedge clk) begin
    spo[3:0] = mem[a][31:24];
    spo[7:4] = mem[a][23:16];
    spo[11:8] = mem[a][15:8];
    spo[15:12] = mem[a][7:0];
    spo[91:16] = {a, mem[a]};
  end

endmodule