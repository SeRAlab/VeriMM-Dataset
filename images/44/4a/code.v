module top_module(input [3:0] A, input [3:0] B, output [3:0] S, output C);wire [4:0] temp;

    assign temp = A + B;

    assign S = temp[3:0];

    assign C = (temp[4] == 1);

endmodule