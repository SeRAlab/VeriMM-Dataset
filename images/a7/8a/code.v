module top_module(
    input [3:0] D,
    input SHL,
    input SHR,
    input LOAD,
    output reg [3:0] Q
);always @ (posedge LOAD)
        if (LOAD)
            Q <= D;

    always @ (posedge SHL)
        if (SHL)
            Q <= {Q[2:0], 1'b0};

    always @ (posedge SHR)
        if (SHR)
            Q <= {1'b0, Q[3:1]};

endmodule