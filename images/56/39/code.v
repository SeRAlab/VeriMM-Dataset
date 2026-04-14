module top_module(
    input [3:0] I,
    input [1:0] S,
    output reg O
    );always @ (*)
        case ({S})
            2'b00: O = I[0];
            2'b01: O = I[1];
            2'b10: O = I[2];
            2'b11: O = I[3];
        endcase

endmodule