module top_module( ONEPOS, ONENEG, TWOPOS, TWONEG, INA, INB, INC, IND, PPBIT );input  ONEPOS;
    input  ONENEG;
    input  TWOPOS;
    input  TWONEG;
    input  INA;
    input  INB;
    input  INC;
    input  IND;
    output PPBIT;

    wire A, B, C, D, E;

    assign A = ~(INA & TWOPOS);
    assign B = ~(INB & TWONEG);
    assign C = ~(INC & ONEPOS);
    assign D = ~(IND & ONENEG);
    assign E = A & B & C & D;
    assign PPBIT = ~E;

endmodule