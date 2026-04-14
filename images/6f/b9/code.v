module binary_multiplier(
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] product
    );
    
    reg [7:0] temp_a;
    reg [3:0] temp_b;
    integer i;
    
    always @(*) begin
        temp_a = {4'b0000, a};
        temp_b = b;
        product = 8'b00000000;
        
        for (i = 0; i < 4; i = i + 1) begin
            if (temp_b[i])
                product = product + (temp_a << i);
        end
    end
endmodule