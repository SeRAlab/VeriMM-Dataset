module top_module(
    input [3:0] in1,
    input [3:0] in2,
    output reg [3:0] out
);always @(*) begin
        if (in1 + in2 <= 9) begin
            out = in1 + in2;
        end else begin
            out = in1 + in2 - 6;
        end
    end

endmodule