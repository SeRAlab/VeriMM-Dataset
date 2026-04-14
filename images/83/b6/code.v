module top_module (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out);
    // State encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

always @(*) begin
    // Default output is 0, will update for specific states if needed
    out = 0;

    // State transition logic
    case(state)
        A: begin
            if (in == 1'b0)
                next_state = C;
            else
                next_state = A;
            out = 1;  // Output is 1 in state A
        end
        B: begin
            if (in == 1'b0)
                next_state = D;
            else
                next_state = A;
            out = 1;  // Output is 1 in state B
        end
        C: begin
            if (in == 1'b0)
                next_state = D;
            else
                next_state = C;
            out = 1;  // Output is 1 in state C
        end
        D: begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = D;
            out = 0;  // Output is 0 in state D
        end
        default: begin
            next_state = A;  // Default transition to state A if invalid state
            out = 0;
        end
    endcase
end

endmodule
