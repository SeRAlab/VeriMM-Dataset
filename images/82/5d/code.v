module top_module(
    output reg Q,
    input D,
    input C,
    input R,
    input S
);parameter [0:0] INIT = 1'b0;
    initial Q = INIT;
    always @(*)
        case (C)
            1'b0:
                if (S)
                    Q <= 1'b1;
                else if (R)
                    Q <= 1'b0;
            1'b1:
                if (S)
                    Q <= 1'b1;
                else if (R)
                    Q <= 1'b0;
                else
                    Q <= D;
        endcase
endmodule