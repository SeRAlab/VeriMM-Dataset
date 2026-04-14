module top_module (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out
);

  // Define state encoding
  localparam Q0 = 2'b00;
  localparam Q1 = 2'b01;
  localparam Q2 = 2'b10;
  localparam Q3 = 2'b11;

  // Combinational logic to determine next state and output based on current state and input
  always @(*) begin
    // Default output
    out = 0;
    
    case (state)
      Q0: begin
        if (in == 0)
          next_state = Q1;
        else
          next_state = Q2;
        out = 0;
      end

      Q1: begin
        if (in == 0)
          next_state = Q3;
        else
          next_state = Q0;
        out = 1;
      end

      Q2: begin
        if (in == 0)
          next_state = Q1;
        else
          next_state = Q3;
        out = 0;
      end

      Q3: begin
        if (in == 0)
          next_state = Q2;
        else
          next_state = Q0;
        out = 1;
      end

      default: begin
        next_state = Q0; // Default to state Q0 if in an undefined state
        out = 0;
      end
    endcase
  end

endmodule