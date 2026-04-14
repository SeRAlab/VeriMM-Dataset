module top_module(
    input [7:0] input1,
    input [7:0] input2,
    input [7:0] input3,
    input [7:0] input4,
    input sel_b1,
    input sel_b2,
    output reg [7:0] out_always
);always @(*) begin
    if (sel_b1 == 0 && sel_b2 == 0) begin
        out_always = input1;
    end
    else if (sel_b1 == 0 && sel_b2 == 1) begin
        out_always = input2;
    end
    else if (sel_b1 == 1 && sel_b2 == 0) begin
        out_always = input3;
    end
    else begin
        out_always = input4;
    end
end

endmodule