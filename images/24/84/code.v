module median_filter (
    input [2:0] in0,
    input [2:0] in1,
    input [2:0] in2,
    output reg [2:0] median
);
    always @(*) begin
        if ((in0 >= in1 && in0 <= in2) || (in0 <= in1 && in0 >= in2))
            median = in0;
        else if ((in1 >= in0 && in1 <= in2) || (in1 <= in0 && in1 >= in2))
            median = in1;
        else
            median = in2;
    end
endmodule