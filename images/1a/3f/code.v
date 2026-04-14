module dwt_2x2 (
    input [3:0] data_in,
    output [3:0] LL,
    output [3:0] LH,
    output [3:0] HL,
    output [3:0] HH
);
    wire [1:0] row0, row1;

    assign row0 = data_in[3:2]; // First row
    assign row1 = data_in[1:0]; // Second row

    assign LL = (row0 + row1) >> 1; // Average for LL
    assign LH = (row0 - row1) >> 1; // Difference for LH
    assign HL = (row1 - row0) >> 1; // Difference for HL
    assign HH = (row0 - row1) >> 1; // Difference for HH

endmodule