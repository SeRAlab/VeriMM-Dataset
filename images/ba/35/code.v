module top_module (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out
);

  // Define state encoding
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;

  // Combinational logic to determine next state and output based on current state and input
  always @(*) begin
    // Default output
    out = 0;
    
    case (state)
      A: begin
        if (in == 0)
          next_state = B;
        else
          next_state = C;
        out = 0;
      end

      B: begin
        if (in == 0)
          next_state = A;
        else
          next_state = C;
        out = 1;
      end

      C: begin
        if (in == 0)
          next_state = B;
        else
          next_state = A;
        out = 0;
      end

      default: begin
        next_state = A; // Default to state A if in an undefined state
        out = 0;
      end
    endcase
  end

endmodule