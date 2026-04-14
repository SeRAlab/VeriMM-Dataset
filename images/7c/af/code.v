module top_module(
    input s, r,
    output reg q, qbar
);always @ (*)
        case({s, r})
            2'b01: {q, qbar} = 2'b01;
            2'b10: {q, qbar} = 2'b10;
            2'b11: {q, qbar} = 2'b00;
            default: {q, qbar} = 2'bxx;
        endcase
endmodule