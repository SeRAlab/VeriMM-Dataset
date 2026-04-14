module top_module (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out
);

  // Define state encoding
  localparam X = 2'b00;
  localparam Y = 2'b01;
  localparam Z = 2'b10;

  // Combinational logic to determine next state and output based on current state and input
  always @(*) begin
    case (state)
      X: begin
        if (in == 0) begin
          next_state = Y;
          out = 1;
        end
        else begin
          next_state = Z;
          out = 0;
        end
      end

      Y: begin
        if (in == 0) begin
          next_state = X;
          out = 0;
        end
        else begin
          next_state = Z;
          out = 1;
        end
      end

      Z: begin
        if (in == 0) begin
          next_state = X;
          out = 1;
        end
        else begin
          next_state = Y;
          out = 0;
        end
      end

      default: begin
        next_state = X; // Default to state X if in an undefined state
        out = 0;
      end
    endcase
  end

endmodule