module top_module(Q,
    O1,
    D,
    wr_clk);output Q;
  output [7:0] O1;
  input [8:0] D;
  input wr_clk;

  reg [8:0] D_sync;
  reg [0:0] Q_sync;

  // Synchronize input signal using D flip-flops
  always @(posedge wr_clk) begin
    D_sync <= D;
    Q_sync <= D[0];
  end

  // Generate output signal O1 using LUTs
  assign O1[0] = Q_sync & D_sync[0] & D_sync[1] & D_sync[2] & ~D_sync[3];
  assign O1[1] = Q_sync & D_sync[0] & D_sync[1] & ~D_sync[2];
  assign O1[2] = D_sync[3] & ~Q_sync;
  assign O1[3] = D_sync[4] & Q_sync & D_sync[5] & D_sync[6] & ~D_sync[7];
  assign O1[4] = D_sync[5] & D_sync[6] & D_sync[7] & ~Q_sync & ~D_sync[8];
  assign O1[5] = Q_sync & D_sync[6] & D_sync[7] & ~D_sync[5];
  assign O1[6] = Q_sync & D_sync[7] & ~D_sync[6];
  assign O1[7] = Q_sync & ~D_sync[7];

endmodule