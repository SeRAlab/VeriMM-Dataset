module multiplexer_4to1 (
    input [1:0] sel,
    input [3:0] in,
    output reg out
);

    always @(sel or in) begin
        case (sel)
            2'b00: out = in[0];
            2'b01: out = in[1];
            2'b10: out = in[2];
            2'b11: out = in[3];
            default: out = 0;
        endcase
    end

endmodule