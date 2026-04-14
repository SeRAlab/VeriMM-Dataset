module top_module (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out
);

  // Define state encoding
  localparam T0 = 2'b00;
  localparam T1 = 2'b01;
  localparam T2 = 2'b10;

  // Combinational logic to determine next state and output based on current state and input
  always @(*) begin
    case (state)
      T0: begin
        if (in == 0) begin
          next_state = T1;
          out = 1;
        end else begin
          next_state = T2;
          out = 0;
        end
      end

      T1: begin
        if (in == 0) begin
          next_state = T2;
          out = 1;
        end else begin
          next_state = T0;
          out = 1;
        end
      end

      T2: begin
        if (in == 0) begin
          next_state = T0;
          out = 0;
        end else begin
          next_state = T1;
          out = 1;
        end
      end

      default: begin
        next_state = T0; // Default to state T0 if in an undefined state
        out = 0;
      end
    endcase
  end

endmodule