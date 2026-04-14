module count_ones (
    input [31:0] A,
    output reg [5:0] B
);
    integer i;
    always @(*) begin
        B = 0;
        for (i = 0; i < 32; i = i + 1) begin
            if (A[i] == 1)
                B = B + 1;
        end
    end
endmodule