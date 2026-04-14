module mult_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [23:0] result
    );

reg [23:0] product;
reg [15:0] multiplicand;
reg [7:0] multiplier;
integer i;

always @(*) begin
    product = 24'b0;
    multiplicand = A;
    multiplier = B;
    for (i = 0; i < 8; i = i + 1) begin
        if (multiplier[i] == 1'b1) begin
            product = product + (multiplicand << i);
        end
    end
end

assign result = product;

endmodule