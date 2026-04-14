module top_module(
    input [3:0] a,
    input [3:0] b,
    input mode,
    output reg [3:0] result
);always @(*) begin
        if (mode == 0) begin
            result = a + b;
        end
        else begin
            result = a - b;
        end
    end

endmodule