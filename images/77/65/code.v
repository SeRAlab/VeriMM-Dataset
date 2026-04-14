module and_module (
    input [7:0] a,
    input [7:0] b,
    input enable,
    input reset,
    output reg [7:0] and_result
);

    always @(*) begin
        if (reset) begin
            and_result = 0;
        end else if (enable) begin
            and_result = a & b;
        end else begin
            and_result = and_result; // Maintain the current value
        end
    end
endmodule