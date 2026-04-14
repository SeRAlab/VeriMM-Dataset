module top_module (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out
);

  // One-hot state encoding
  parameter J = 3'b001;
  parameter K = 3'b010;
  parameter L = 3'b100;

  always @(*) begin
    // Default values
    next_state = 3'b000;
    out = 0;

    case (state)
      J: begin
        if (in == 0)
          next_state = L;
        else
          next_state = K;
        out = 1;
      end

      K: begin
        if (in == 0)
          next_state = J;
        else
          next_state = L;
        out = 0;
      end

      L: begin
        if (in == 0)
          next_state = K;
        else
          next_state = J;
        out = 1;
      end

      default: begin
        next_state = J; // Default to state J in case of an undefined state
        out = 1;
      end
    endcase
  end

endmodule