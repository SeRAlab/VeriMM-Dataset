module multiplier_4bit(a, b, product);

    input [3:0] a;
    input [3:0] b;
    output [7:0] product;
    reg [7:0] product;

    always @(a or b)
    begin
        product = a * b;
    end

endmodule