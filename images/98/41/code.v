module binary_left_shifter
    (
        input [3:0] a,
        input [1:0] shift_amount,
        output [3:0] shifted
    );

    assign shifted = a << shift_amount;

endmodule