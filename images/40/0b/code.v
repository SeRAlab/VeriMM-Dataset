module data_bus (
    input [31:0] A,
    input [31:0] B,
    output [31:0] C
);
    assign C = (A[0] == 1'b1) ? A : B;
endmodule