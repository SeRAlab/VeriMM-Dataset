module top_module(
    input [3:0] A,
    input [3:0] B,
    input mode,
    output reg [3:0] O,
    output reg COUT
);always @(*) begin
    if (mode == 0) begin
        O = A + B;
        COUT = (O[4] == 1) ? 1 : 0;
    end
    else begin
        O = A - B;
        COUT = (O[4] == 1) ? 0 : 1;
    end
end

endmodule