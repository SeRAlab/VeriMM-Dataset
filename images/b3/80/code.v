module top_module(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow,
    output [7:0] final_output
);wire [15:0] product;
wire [8:0] sum;
wire msb_in_a, msb_in_b, msb_out;
assign msb_in_a = a[7];
assign msb_in_b = b[7];

// Define a simple array multiplier for 8-bit inputs
wire [15:0] partial_products[7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: partial_product_gen
        assign partial_products[i] = (b[i] ? ({8'b0, a} << i) : 16'b0);
    end
endgenerate

assign product = partial_products[0] + partial_products[1] + partial_products[2] +
                 partial_products[3] + partial_products[4] + partial_products[5] +
                 partial_products[6] + partial_products[7];

// Compute the sum of the lower and upper halves of the product
assign sum = product[7:0] + product[15:8];

assign s = sum[7:0];
assign msb_out = sum[8];

// Determine overflow
assign overflow = (msb_in_a == msb_in_b) && (msb_in_a != msb_out);

// Simple overflow detector
assign final_output = (overflow) ? 8'b11111111 : s;

endmodule