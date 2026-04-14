module top_module(
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire [3:0] C,
    input  wire [3:0] D,
    output wire [3:0] SUM,
    output wire       CARRY
);wire [3:0] sum_temp;
    wire carry_temp;

    // add A, B, C, and D
    assign sum_temp = A + B + C + D;

    // check for carry-out from the most significant bit
    assign carry_temp = sum_temp[3];

    // assign outputs
    assign SUM = sum_temp;
    assign CARRY = carry_temp;

endmodule