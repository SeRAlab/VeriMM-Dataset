module top_module(
    input [7:0] in,
    input [2:0] shift,
    input direction,
    output reg [7:0] out
);always @(*) begin
    case (direction)
        1'b0: begin // left shift
            out = in << shift; // Left shift
        end
        1'b1: begin // right shift
            out = in >> shift; // Right shift
        end
        default: begin
            out = in; // Default case
        end
    endcase
end

endmodule