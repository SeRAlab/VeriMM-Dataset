module top_module(
    input [1:0] in,
    input sel,
    output reg out
);always @(*) begin
        case(sel)
            0: out = in[0];
            1: out = in[1];
        endcase
    end

endmodule