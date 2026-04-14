module top_module(
  input clk,
  input reset,
  input a,
  input b,
  input c,
  output reg d
);reg [1:0] state, next_state;

  parameter S0 = 2'b00, S1 = 2'b01;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case (state)
      S0: begin
        if (a & ~b & ~c) begin
          next_state = S1;
          d = 1'b0;
        end else if (~a & ~b & c) begin
          next_state = S0;
          d = 1'b0;
        end else begin
          next_state = S0;
          d = 1'b1;
        end
      end
      S1: begin
        if (~a & ~b & ~c) begin
          next_state = S0;
          d = 1'b1;
        end else if (~a & ~b & c) begin
          next_state = S1;
          d = 1'b1;
        end else begin
          next_state = S1;
          d = 1'b0;
        end
      end
      default: begin
        next_state = S0;
        d = 1'b0;
      end
    endcase
  end

endmodule