module top_module(CLOCKENABLE, INPUTCLK, LATCHINPUTVALUE, PARALLELLOAD, SERIALIN, SERIALOUT, Q);parameter WIDTH = 8;
  input CLOCKENABLE;
  input INPUTCLK;
  input LATCHINPUTVALUE;
  input PARALLELLOAD;
  input SERIALIN;
  output SERIALOUT;
  output reg [WIDTH-1:0] Q;
  reg [WIDTH-1:0] shift_reg;

  always @(posedge CLOCKENABLE) begin
    if (LATCHINPUTVALUE) begin
      shift_reg <= {SERIALIN, shift_reg[WIDTH-1:1]};
    end else if (PARALLELLOAD) begin
      shift_reg <= SERIALIN;
    end else begin
      if (Q[0]) begin
        shift_reg <= {shift_reg[WIDTH-2:0], SERIALIN};
      end else begin
        shift_reg <= {SERIALIN, shift_reg[WIDTH-1:1]};
      end
    end
  end

  assign SERIALOUT = shift_reg[0];
  assign Q = shift_reg;

endmodule