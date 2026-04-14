module top_module(
  input clk,
  input reset,
  input i,
  output reg out
);parameter STATE_A = 2'b00;
  parameter STATE_B = 2'b01;
  parameter STATE_C = 2'b10;

  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= STATE_A;
      out <= 1'b0;
    end
    else begin
      state <= next_state;
      out <= (state == STATE_C) ? 1'b1 : 1'b0;
    end
  end

  always @(*) begin
    case (state)
      STATE_A: begin
        if (i) next_state = STATE_B;
        else next_state = STATE_A;
      end
      STATE_B: begin
        if (i) next_state = STATE_C;
        else next_state = STATE_A;
      end
      STATE_C: begin
        if (i) next_state = STATE_B;
        else next_state = STATE_A;
      end
    endcase
  end

endmodule