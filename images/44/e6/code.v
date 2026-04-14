module top_module(
    input [3:0] D0,
    input [3:0] D1,
    input [3:0] D2,
    input [3:0] D3,
    input [1:0] S,
    output reg [3:0] Y  // Change output to reg type
);always @*
    begin
        case (S)
            2'b00: Y = D0;
            2'b01: Y = D1;
            2'b10: Y = D2;
            2'b11: Y = D3;
            default: Y = 4'hX;
        endcase
    end

endmodule