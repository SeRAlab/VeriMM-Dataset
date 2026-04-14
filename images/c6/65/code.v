module xor_gate(input a, b, output out);
    reg out;
    always @ (a, b)
        case ({a, b})
            2'b00: out = 1'b0;
            2'b01: out = 1'b1;
            2'b10: out = 1'b1;
            2'b11: out = 1'b0;
        endcase
endmodule