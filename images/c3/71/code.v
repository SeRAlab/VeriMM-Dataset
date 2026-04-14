module mux4(input [7:0] A, input [7:0] B, input [7:0] C, input [7:0] D, input E, input [1:0] S, output reg [7:0] Y);

always @(*)
begin
    if (E == 0)
        Y = 0;
    else if (S == 2'b00)
        Y = A;
    else if (S == 2'b01)
        Y = B;
    else if (S == 2'b10)
        Y = C;
    else if (S == 2'b11)
        Y = D;
end

endmodule