module top_module (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out
);

  // One-hot state encoding
  parameter S1 = 3'b001;
  parameter S2 = 3'b010;
  parameter S3 = 3'b100;

  always @(*) begin
    // Default values
    next_state = 3'b000;
    out = 0;

    case (state)
      S1: begin
        if (in == 0)
          next_state = S2;
        else
          next_state = S3;
        out = 0;
      end

      S2: begin
        if (in == 0)
          next_state = S1;
        else
          next_state = S3;
        out = 1;
      end

      S3: begin
        if (in == 0)
          next_state = S2;
        else
          next_state = S1;
        out = 0;
      end

      default: begin
        next_state = S1; // Default to state S1 in case of an undefined state
        out = 0;
      end
    endcase
  end

endmodule