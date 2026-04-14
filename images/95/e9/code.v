module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [3:0] E,
    output reg X
);reg [3:0] sum;
    reg [3:0] max;

    always @*
    begin
        sum = A + B + C + D + E;
        max = A;
        if (B > max) max = B;
        if (C > max) max = C;
        if (D > max) max = D;
        if (E > max) max = E;
    end

    always @(sum, max)
    begin
        if (sum >= max) X = 1;
        else X = 0;
    end

endmodule