module top_module(
    input wire sel,
    input wire [15:0] a_in,
    input wire [15:0] b_in,
    output reg [15:0] out
);always @(*) begin
        case(sel)
            1'b0: out = a_in;
            1'b1: out = b_in;
            default: out = 16'b0;
        endcase
    end

endmodule