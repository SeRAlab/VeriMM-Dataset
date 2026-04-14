module top_module(
  input [2:0] tstate,
  input foocr_we,
  input ioclrinst,
  input fooc2_qual,
  output reg [2:0] ntstate,
  output reg ioclrtmout
);parameter TIDLE = 3'b000;
  parameter TCN1 = 3'b001;
  parameter TCN2 = 3'b010;
  parameter TCN3 = 3'b011;
  parameter TCN4 = 3'b100;
  parameter TCN5 = 3'b101;
  parameter IOCLR = 3'b110;
  parameter TUNU1 = 3'b111;

  always @(*) begin
    case (tstate)
      TIDLE: begin
        if (foocr_we)
          ntstate = TCN1;
        else
          ntstate = TIDLE;
        ioclrtmout = 1'b0;
      end
      TCN1, TCN2, TCN3, TCN4, TCN5: begin
        if (ioclrinst || fooc2_qual)
          ntstate = TIDLE;
        else if (tstate == TCN5)
          ntstate = IOCLR;
        else
          ntstate = tstate + 1;
        ioclrtmout = 1'b0;
      end
      IOCLR: begin
        ntstate = TIDLE;
        ioclrtmout = 1'b1;
      end
      TUNU1: begin
        ntstate = TIDLE;
        ioclrtmout = 1'b0;
      end
      default: begin
        ntstate = 3'bx;
        ioclrtmout = 1'bx;
      end
    endcase
  end

endmodule