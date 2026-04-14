module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      match <= 0;
    end
    else begin
      state <= next_state;
      match <= 0;
      case (state)
        A: begin
          if (data == 0) next_state = A;
          else if (data == 1) next_state = B;
          else next_state = A;
        end
        B: begin
          if (data == 0) next_state = C;
          else if (data == 1) next_state = B;
          else next_state = A;
        end
        C: begin
          if (data == 0) next_state = A;
          else if (data == 1) next_state = B;
          else next_state = D;
        end
        D: begin
          if (data == 0) next_state = A;
          else if (data == 1) next_state = B;
          else next_state = A;
          if (state == C) match <= 1;
        end
      endcase
    end
  end

endmodule