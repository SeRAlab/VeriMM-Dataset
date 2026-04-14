module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    output [3:0] S,
    output OV,
    output UF
);wire [4:0] temp;
    assign temp = (C == 0) ? ({1'b0, A} + {1'b0, B}) : ({1'b0, A} - {1'b0, B});

    assign OV = (temp[4] == 1) ? 1 : 0;
    assign UF = (temp[3:0] < 4'b0000) ? 1 : 0;
    assign S = (OV || UF) ? 4'b0000 : temp[3:0];

endmodule