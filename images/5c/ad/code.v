module or_module (
    input [7:0] a,
    input [7:0] b,
    input enable,
    input reset,
    output reg [7:0] or_result
);

    always @(*) begin
        if (reset) begin
            or_result = 0;
        end else if (enable) begin
            or_result = a | b;
        end else begin
            or_result = or_result; // Maintain the current value
        end
    end
endmodule