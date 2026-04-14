module xor_module (
    input [7:0] a,
    input [7:0] b,
    input enable,
    input reset,
    output reg [7:0] xor_result
);

    always @(*) begin
        if (reset) begin
            xor_result = 0;
        end else if (enable) begin
            xor_result = a ^ b;
        end else begin
            xor_result = xor_result; // Maintain the current value
        end
    end
endmodule