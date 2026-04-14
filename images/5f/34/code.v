module top_module(
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    input [15:0] in4,
    input reset,
    output reg [15:0] out1,
    output reg [15:0] out2
);always @(*) begin
        if (reset) begin
            out1 <= 16'b0;
            out2 <= 16'b0;
        end else begin
            out1 <= in1 & in2;
            out2 <= in3 ^ in4;
        end
    end

endmodule