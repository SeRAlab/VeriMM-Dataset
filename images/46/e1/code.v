module top_module (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out
);

  // One-hot state encoding
  parameter D = 3'b001;
  parameter E = 3'b010;
  parameter F = 3'b100;

  always @(*) begin
    // Default values
    next_state = 3'b000;
    out = 0;

    case (state)
      D: begin
        if (in == 0)
          next_state = E;
        else
          next_state = F;
        out = 0;
      end

      E: begin
        if (in == 0)
          next_state = F;
        else
          next_state = D;
        out = 1;
      end

      F: begin
        if (in == 0)
          next_state = D;
        else
          next_state = E;
        out = 0;
      end

      default: begin
        next_state = D; // Default to state D in case of an undefined state
        out = 0;
      end
    endcase
  end

endmodule