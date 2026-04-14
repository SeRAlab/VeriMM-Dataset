module multiplier_32bit (
    input [31:0] a, 
    input [31:0] b, 
    output reg [63:0] product
);
    integer i;
    reg [63:0] temp_product;

    always @(*) begin
        temp_product = 0; // Initialize the product to 0
        for (i = 0; i < 32; i = i + 1) begin
            if (b[i]) begin
                temp_product = temp_product + (a << i); // Shift a left by i and add to product if b[i] is 1
            end
        end
        product = temp_product; // Assign the final product
    end
endmodule