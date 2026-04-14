module multiplier_4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] product
);
    wire [3:0] partial_product[3:0];
    wire [4:0] sum[2:0];

    assign partial_product[0] = a & {4{b[0]}};
    assign partial_product[1] = a & {4{b[1]}};
    assign partial_product[2] = a & {4{b[2]}};
    assign partial_product[3] = a & {4{b[3]}};

    assign sum[0] = {1'b0, partial_product[0]} + {partial_product[1], 1'b0};
    assign sum[1] = {1'b0, partial_product[2]} + {partial_product[3], 1'b0};

    assign product = sum[0] + {sum[1], 2'b00};
endmodule