module top_module(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] max,
    output reg equal_flag
);always @(*) begin
    if (a > b) begin
        max = a;
        equal_flag = 0;
    end
    else if (b > a) begin
        max = b;
        equal_flag = 0;
    end
    else begin
        max = a;
        equal_flag = 1;
    end
end

endmodule