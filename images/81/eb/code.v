module top_module(
    input [3:0] A,
    input [3:0] B,
    input mode,
    output reg [3:0] Y
);reg [3:0] temp1;
    reg [3:0] temp2;

    always @ (A, B, mode)
    begin
        temp1 = A;
        temp2 = B;

        case (mode)
            0: Y = temp1 + temp2;
            1: Y = temp1 - temp2;
            default: Y = 4'b0000;
        endcase

        if (mode == 1)
            Y = -Y;
    end

endmodule