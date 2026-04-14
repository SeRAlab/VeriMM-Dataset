module not_module (
    input [7:0] a,
    input enable,
    input reset,
    output reg [7:0] not_result
);

    always @(*) begin
        if (reset) begin
            not_result = 0;
        end else if (enable) begin
            not_result = ~a;
        end else begin
            not_result = not_result; // Maintain the current value
        end
    end
endmodule