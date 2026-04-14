module comparator_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg A_less,
    output reg A_equal,
    output reg A_greater
);
    always @(*) begin
        if (A < B) begin
            A_less = 1;
            A_equal = 0;
            A_greater = 0;
        end else if (A == B) begin
            A_less = 0;
            A_equal = 1;
            A_greater = 0;
        end else begin
            A_less = 0;
            A_equal = 0;
            A_greater = 1;
        end
    end
endmodule