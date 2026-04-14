module comparator (
    input [3:0] in0,
    input [3:0] in1,
    output reg eq,
    output reg gt,
    output reg lt
);

    always @(*) begin
        eq = (in0 == in1);
        gt = (in0 > in1);
        lt = (in0 < in1);
    end

endmodule