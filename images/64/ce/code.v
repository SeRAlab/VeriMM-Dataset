module top_module(op, AI, BI, CI, OUT, C, Z, N, V);input [1:0] op;
    input [7:0] AI;
    input [7:0] BI;
    input CI;
    output reg [7:0] OUT;
    output reg C;
    output Z;
    output N;
    output V;

    always @ ( * ) begin
        case (op)
            2'b00: {C, OUT} <= AI + BI + CI;
            2'b01: {C, OUT} <= AI - BI;
            2'b10: {C, OUT} <= AI + 1;
            2'b11: {C, OUT} <= AI - 1;
        endcase
    end

    assign Z = OUT == 7'h0;
    assign N = OUT[7];
    assign V = AI[7] ^ BI[7] ^ C ^ N;

endmodule