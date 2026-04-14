module multiplier_module (
    input [3:0] a,
    input [3:0] b,
    input enable,
    input reset,
    output reg [7:0] product
);

    always @(*) begin
        if (reset) begin
            product = 0;
        end else if (enable) begin
            product = a * b;
        end else begin
            product = product; // Maintain the current value
        end
    end
endmodule