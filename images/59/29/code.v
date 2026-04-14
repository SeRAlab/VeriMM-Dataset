module top_module(
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input sel0,
    input sel1,
    output reg [7:0] out
);always @ (sel0 or sel1 or in1 or in2 or in3 or in4)
begin
    if (sel0 == 0 && sel1 == 0)
        out = in1;
    else if (sel0 == 1 && sel1 == 0)
        out = in2;
    else if (sel0 == 0 && sel1 == 1)
        out = in3;
    else if (sel0 == 1 && sel1 == 1)
        out = in4;
end

endmodule