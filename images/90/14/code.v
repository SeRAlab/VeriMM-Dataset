module conditional_or(
    input a,
    input b,
    input ctrl,
    output reg z);always @(*) begin
    if (ctrl)
        z = a | b;
    else
        z = 0;
end

endmodule