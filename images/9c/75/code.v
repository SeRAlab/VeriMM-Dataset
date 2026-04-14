module top_module(
    input [2:0] in,
    output reg [7:0] out
);always @(*) begin
        out = 8'b0; // Initialize output to zero

        case(in)
            3'b100: out[1] = 1'b1; // Highest priority
            3'b010: out[2] = 1'b1;
            3'b001: out[4] = 1'b1;
            default: out[0] = 1'b1; // No valid input
        endcase
    end

endmodule