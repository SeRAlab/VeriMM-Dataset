module comparator_64bit (
    input [63:0] a,
    input [63:0] b,
    output reg eq,
    output reg lt,
    output reg gt
);
    always @(*) begin
        if (a == b) begin
            eq = 1;
            lt = 0;
            gt = 0;
        end else if (a < b) begin
            eq = 0;
            lt = 1;
            gt = 0;
        end else begin
            eq = 0;
            lt = 0;
            gt = 1;
        end
    end
endmodule