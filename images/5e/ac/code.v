module shift_right_module (
    input [7:0] a,
    input enable,
    input reset,
    output reg [7:0] shift_result
);

    always @(*) begin
        if (reset) begin
            shift_result = 0;
        end else if (enable) begin
            shift_result = a >> 1;
        end else begin
            shift_result = shift_result; // Maintain the current value
        end
    end
endmodule