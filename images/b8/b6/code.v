module top_module(
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [7:0] product,
    output overflow
);reg signed [7:0] temp_product;
    reg signed [3:0] temp_a;
    reg signed [3:0] temp_b;
    reg overflow_flag;
    
    always @(*) begin
        temp_a = (a < 0) ? (~a + 1) : a;
        temp_b = (b < 0) ? (~b + 1) : b;
        temp_product = temp_a * temp_b;
        if (temp_product > 127 || temp_product < -128) begin
            overflow_flag = 1;
        end else begin
            overflow_flag = 0;
        end
    end
    
    assign product = (a < 0) ^ (b < 0) ? (~temp_product + 1) : temp_product;
    assign overflow = overflow_flag;
    
endmodule