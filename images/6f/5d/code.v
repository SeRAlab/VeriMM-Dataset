module top_module (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out
);

  // One-hot state encoding
  parameter G = 3'b001;
  parameter H = 3'b010;
  parameter I = 3'b100;

  always @(*) begin
    // Default values
    next_state = 3'b000;
    out = 0;

    case (state)
      G: begin
        if (in == 0)
          next_state = H;
        else
          next_state = I;
        out = 1;
      end

      H: begin
        if (in == 0)
          next_state = I;
        else
          next_state = G;
        out = 1;
      end

      I: begin
        if (in == 0)
          next_state = G;
        else
          next_state = H;
        out = 0;
      end

      default: begin
        next_state = G; // Default to state G in case of an undefined state
        out = 1;
      end
    endcase
  end

endmodule