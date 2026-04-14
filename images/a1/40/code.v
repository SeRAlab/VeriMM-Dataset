module top_module(Q,
    I1,
    rd_clk,
    I3,
    wr_clk,
    D);output [11:0]Q;
  input [11:0]I1;
  input rd_clk;
  input [0:0]I3;
  input wr_clk;
  input [11:0]D;

  wire [11:0]I1;
  wire [0:0]I3;
  wire [11:0]Q;
  wire rd_clk;
  reg [11:0]Q_reg;
  wire wr_clk;
  wire [11:0]D;

  always @(posedge rd_clk or posedge I3) begin
    if (I3) begin
      Q_reg <= 12'b0;
    end else begin
      Q_reg <= I1;
    end
  end

  always @(posedge wr_clk) begin
    Q_reg <= D;
  end

  assign Q = Q_reg;
endmodule