module top_module(
    input [15:0] a,
    input [15:0] b,
    output [31:0] out
);reg [31:0] product;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    integer i;

    always @(*) begin
        product = 32'h0;
        multiplicand = a;
        multiplier = b;

        for (i = 0; i < 16; i = i + 1) begin
            if (multiplier[0] == 1) begin
                product = product + (multiplicand << i);
            end
            multiplier = multiplier >> 1;
        end
    end

    assign out = product;
endmodule