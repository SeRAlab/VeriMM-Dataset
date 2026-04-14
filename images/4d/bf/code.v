module top_module(
  input clk,
  input reset,
  input [2:0] data,
  output reg match
);// State definition
  parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101, G = 3'b110;
  reg [2:0] state, next_state;

  // Output default value
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
      match <= 1'b0;  // Reset match on reset signal
    end else begin
      state <= next_state;
    end
  end

  // State transition and output logic
  always @(*) begin
    match = 1'b0; // Default value for match
    case(state)
      A: begin
        next_state = (data == 3'b101) ? G : (data == 3'b001) ? A : B;
      end
      B: begin
        next_state = (data == 3'b001) ? B : (data == 3'b010) ? C : A;
      end
      C: begin
        next_state = (data == 3'b001) ? B : (data == 3'b010) ? D : A;
      end
      D: begin
        next_state = (data == 3'b001) ? B : (data == 3'b010) ? E : A;
      end
      E: begin
        next_state = (data == 3'b001) ? B : (data == 3'b010) ? F : A;
      end
      F: begin
        next_state = (data == 3'b001) ? F : (data == 3'b010) ? A : G;
      end
      G: begin
        next_state = A;
        match = (data == 3'b101) ? 1'b1 : 1'b0;
      end
      default: begin
        next_state = A; // Default state
      end
    endcase
  end
endmodule