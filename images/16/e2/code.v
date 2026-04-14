module wallace_tree_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);

wire [3:0] partial_prod [0:3];

// Generate partial products
assign partial_prod[0] = A & {4{B[0]}};
assign partial_prod[1] = A & {4{B[1]}};
assign partial_prod[2] = A & {4{B[2]}};
assign partial_prod[3] = A & {4{B[3]}};

// Wallace tree reduction
wire [4:0] sum [0:2];
wire [3:0] carry [0:2];

// First level of reduction
assign sum[0] = partial_prod[0] + partial_prod[1][1:0];
assign carry[0] = {1'b0, partial_prod[1][3:2]} + (partial_prod[2][1:0]);
assign sum[1] = sum[0] + carry[0];
assign carry[1] = {1'b0, partial_prod[2][3:2]} + (partial_prod[3][1:0]);
assign sum[2] = sum[1] + carry[1];

// Final addition
assign P = {1'b0, sum[2]} + {carry[2], partial_prod[3][3:2]};

endmodule