module top_module(add_overflow_flag,
    E,
    O,
    CLK,
    AR);output add_overflow_flag;
  input [0:0]E;
  input [0:0]O;
  input CLK;
  input [0:0]AR;

  wire [0:0]AR;
  wire CLK;
  wire [0:0]E;
  wire [0:0]O;
  wire add_overflow_flag;

  reg [0:0] Q_reg;
  always @(posedge CLK or negedge AR)
  begin
    if (!AR)
      Q_reg <= 1'b0;
    else if (E)
      Q_reg <= O;
  end

  assign add_overflow_flag = (E & O & Q_reg);

endmodule