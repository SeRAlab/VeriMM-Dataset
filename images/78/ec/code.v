module top_module(a, b, mode, y);input [11:0] a, b;
  input [1:0] mode;
  output [11:0] y;

  wire aSign = a[11];
  wire bSign = b[11];
  wire [12:0] r = {1'b0, a} + {1'b0, b};
  wire rSign = r[11];
  wire cout = r[12];
  wire vFlag = (~aSign & ~bSign & rSign) | (aSign & bSign & ~rSign);

  reg [11:0] sSatSum = 12'h000;
  always @* begin
    case (vFlag)
      1'b0: sSatSum = r[11:0];
      1'b1: sSatSum = (aSign == 1 && bSign == 1 && rSign == 0) ? 12'h800 : 12'h7ff;
    endcase
  end

  reg [11:0] uSatSum = 12'h000;
  always @* begin
    case (cout)
      1'b0: uSatSum = r[11:0];
      1'b1: uSatSum = 12'hfff;
    endcase
  end

  reg [11:0] result = 12'h000;
  always @* begin
    case (mode)
      2'b00: result = uSatSum;
      2'b01: result = sSatSum;
      2'b10: result = r[11:0];
      2'b11: result = r[11:0];
    endcase
  end

  assign y = result;

endmodule