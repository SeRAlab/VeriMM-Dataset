module top_module(
  input clk,
  input reset,
  output reg out
);parameter S0 = 2'b00; // initial state
  parameter S1 = 2'b01; // state to output 1
  parameter S2 = 2'b10; // state to output 0

  reg [1:0] state; // current state of the FSM

  always @(posedge clk) begin
    if (reset) begin
      state <= S0; // reset to initial state
      out <= 0; // output 0
    end else begin
      case (state)
        S0: begin
          state <= S1; // go to output 1 state
          out <= 1; // output 1
        end
        S1: begin
          if (state == 10) begin
            state <= S2; // go to output 0 state
            out <= 0; // output 0
          end else begin
            state <= state + 1; // increment state
            out <= 1; // output 1
          end
        end
        S2: begin
          state <= S2; // stay in output 0 state
          out <= 0; // output 0
        end
      endcase
    end
  end

endmodule