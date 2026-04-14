module barrel_shifter_8bit (
    input [7:0] in,
    input [2:0] shift,
    input direction,
    output reg [7:0] out
);

    always @(*) begin
        if (direction == 0) // Left shift
            out = {in[shift[2]:7], in[6:shift[2]]};
        else // Right shift
            out = {in[1+shift[2]:0], in[7:1+shift[2]]};
    end

endmodule