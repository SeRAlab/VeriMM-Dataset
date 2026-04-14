module dot_product (
    input [4:0] vec_a,
    input [4:0] vec_b,
    output reg [10:0] dot_product,
    output reg valid
);
    integer i;
    always @(*) begin
        dot_product = 11'b0; // Reset dot product
        valid = 1'b0; // Default valid signal to low
        for (i = 0; i < 5; i = i + 1) begin
            dot_product = dot_product + (vec_a[i] * vec_b[i]);
        end
        valid = 1'b1; // Set valid signal high after computation
    end
endmodule