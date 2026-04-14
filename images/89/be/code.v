module top_module (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out
);

  // Define state encoding
  localparam S0 = 3'b000;
  localparam S1 = 3'b001;
  localparam S2 = 3'b010;
  localparam S3 = 3'b011;
  localparam S4 = 3'b100;

  // Combinational logic to determine next state and output based on current state and input
  always @(*) begin
    // Default output
    out = 0;
    
    case (state)
      S0: begin
        if (in == 0)
          next_state = S1;
        else
          next_state = S2;
        out = 0;
      end

      S1: begin
        if (in == 0)
          next_state = S3;
        else
          next_state = S4;
        out = 0;
      end

      S2: begin
        if (in == 0)
          next_state = S0;
        else
          next_state = S3;
        out = 1;
      end

      S3: begin
        if (in == 0)
          next_state = S4;
        else
          next_state = S0;
        out = 0;
      end

      S4: begin
        if (in == 0)
          next_state = S1;
        else
          next_state = S2;
        out = 1;
      end

      default: begin
        next_state = S0; // Default to state S0 if in an undefined state
        out = 0;
      end
    endcase
  end

endmodule