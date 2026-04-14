module top_module (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out
);

  // One-hot state encoding
  parameter P = 3'b001;
  parameter Q = 3'b010;
  parameter R = 3'b100;

  always @(*) begin
    // Default values
    next_state = 3'b000;
    out = 0;

    case (state)
      P: begin
        if (in == 0)
          next_state = Q;
        else
          next_state = P;
        out = 0;
      end

      Q: begin
        if (in == 0)
          next_state = R;
        else
          next_state = P;
        out = 1;
      end

      R: begin
        if (in == 0)
          next_state = Q;
        else
          next_state = R;
        out = 0;
      end

      default: begin
        next_state = P; // Default to state P in case of an undefined state
        out = 0;
      end
    endcase
  end

endmodule