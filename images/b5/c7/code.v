module comp_32bit(
    input wire [31:0] A,
    input wire [31:0] B,
    output reg is_equal,
    output reg is_greater,
    output reg is_less
    );

always @(*) begin
    if (A == B) begin
        is_equal = 1;
        is_greater = 0;
        is_less = 0;
    end
    else if (A > B) begin
        is_equal = 0;
        is_greater = 1;
        is_less = 0;
    end
    else begin
        is_equal = 0;
        is_greater = 0;
        is_less = 1;
    end
end

endmodule