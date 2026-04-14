module top_module(
    input [3:0] multiplier,
    input [3:0] multiplicand,
    output reg [7:0] product
);integer i, j;

    always @(*) begin
        product = 0;
        for (i = 0; i < 4; i = i + 1) begin
            if (multiplier[i] == 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    if (multiplicand[j] == 1) begin
                        product[i+j] = product[i+j] + 1;
                    end
                end
            end
        end
    end

endmodule