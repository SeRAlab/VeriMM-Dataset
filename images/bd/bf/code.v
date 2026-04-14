module top_module(
  input clk,
  input reset,
  input in0,
  input in1,
  input in2,
  output reg out
);parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;
  reg [2:0] state, next_state;
  
  always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      state <= A;
      out <= 0;
    end
    else begin
      state <= next_state;
      case(state)
        A: begin
          if (in0 == 1) next_state = B;
          else if (in1 == 1) next_state = A;
          else if (in2 == 1) next_state = D;
          out <= 0;
        end
        B: begin
          if (in0 == 1) next_state = C;
          else if (in1 == 1) next_state = A;
          else if (in2 == 1) next_state = E;
          out <= 0;
        end
        C: begin
          if (in0 == 1) next_state = A;
          else if (in1 == 1) next_state = D;
          else if (in2 == 1) next_state = E;
          out <= 1;
        end
        D: begin
          if (in0 == 1) next_state = E;
          else if (in1 == 1) next_state = E;
          else if (in2 == 1) next_state = A;
          out <= 1;
        end
        E: begin
          next_state = E;
          out <= 0;
        end
      endcase
    end
  end

endmodule