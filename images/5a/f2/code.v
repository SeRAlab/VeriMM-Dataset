module adder_module (
    input [3:0] a,
    input [3:0] b,
    input enable,
    input reset,
    output reg [3:0] sum
);

    always @(*) begin
        if (reset) begin
            sum = 0;
        end else if (enable) begin
            sum = a + b;
        end else begin
            sum = sum; // Maintain the current value
        end
    end
endmodule