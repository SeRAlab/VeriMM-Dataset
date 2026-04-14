module barrel_shifter (
    input [3:0] in,
    input [1:0] shift,
    input dir, // 0 for left, 1 for right
    output reg [3:0] out
);

    always @(*) begin
        case(shift)
            2'b00: out = in;
            2'b01: out = dir ? in >> 1 : in << 1;
            2'b10: out = dir ? in >> 2 : in << 2;
            2'b11: out = dir ? in >> 3 : in << 3;
            default: out = in;
        endcase
    end

endmodule