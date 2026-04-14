module top_module(
    input in0,
    input in1,
    input in2,
    input in3,
    output reg out
);always @(*) begin
    if (in0 == 0 && in1 == 0 && in2 == 0 && in3 == 0) begin
        out = 0;
    end else if (in0 == 1 && in1 == 1 && in2 == 1 && in3 == 1) begin
        out = 1;
    end else begin
        out = 0;
    end
end

endmodule