module Comparator8bit (
	input [7:0] a,
	input [7:0] b,
	output reg gt,
	output reg eq,
	output reg lt
);
    always @(*) begin
        if (a > b) begin
            gt = 1;
            eq = 0;
            lt = 0;
        end else if (a == b) begin
            gt = 0;
            eq = 1;
            lt = 0;
        end else begin
            gt = 0;
            eq = 0;
            lt = 1;
        end
    end
endmodule