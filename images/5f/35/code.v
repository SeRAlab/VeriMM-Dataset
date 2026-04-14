module binary_multiplier (
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] product
);

    integer i;

    always @(*) begin
        product = 8'b00000000;
        for (i = 0; i < 4; i = i + 1) begin
            if (b[i])
                product = product + (a << i);
        end
    end

endmodule