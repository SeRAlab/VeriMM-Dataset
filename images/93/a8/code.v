module top_module (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out
);

  // One-hot state encoding
  parameter X = 3'b001;
  parameter Y = 3'b010;
  parameter Z = 3'b100;

  always @(*) begin
    // Default values
    next_state = 3'b000;
    out = 0;

    case (state)
      X: begin
        if (in == 0)
          next_state = Z;
        else
          next_state = Y;
        out = 0;
      end

      Y: begin
        if (in == 0)
          next_state = X;
        else
          next_state = Z;
        out = 1;
      end

      Z: begin
        if (in == 0)
          next_state = Y;
        else
          next_state = X;
        out = 0;
      end

      default: begin
        next_state = X; // Default to state X in case of an undefined state
        out = 0;
      end
    endcase
  end

endmodule