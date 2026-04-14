module top_module (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out
);

  // Define state encoding
  localparam P0 = 2'b00;
  localparam P1 = 2'b01;
  localparam P2 = 2'b10;
  localparam P3 = 2'b11;

  // Combinational logic to determine next state and output based on current state and input
  always @(*) begin
    case (state)
      P0: begin
        if (in == 0) begin
          next_state = P1;
          out = 1;
        end else begin
          next_state = P2;
          out = 0;
        end
      end

      P1: begin
        if (in == 0) begin
          next_state = P2;
          out = 0;
        end else begin
          next_state = P3;
          out = 1;
        end
      end

      P2: begin
        if (in == 0) begin
          next_state = P0;
          out = 0;
        end else begin
          next_state = P3;
          out = 1;
        end
      end

      P3: begin
        if (in == 0) begin
          next_state = P1;
          out = 1;
        end else begin
          next_state = P0;
          out = 0;
        end
      end

      default: begin
        next_state = P0; // Default to state P0 if in an undefined state
        out = 0;
      end
    endcase
  end

endmodule