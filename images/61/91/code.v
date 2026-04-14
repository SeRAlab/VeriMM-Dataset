module mult_8bit(
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [15:0] product
    );

wire [7:0] pp[7:0];
wire [14:0] sum[6:0];
wire [14:0] carry[6:0];

genvar i, j;

generate
    for (i = 0; i < 8; i = i + 1) begin
        for (j = 0; j < 8; j = j + 1) begin
            assign pp[i][j] = A[i] & B[j];
        end
    end
endgenerate

assign product[0] = pp[0][0];

generate
    for (i = 0; i < 7; i = i + 1) begin
        assign {carry[i][0], sum[i][0]} = pp[i+1][0] + pp[i][1];
        for (j = 1; j < 7; j = j + 1) begin
            full_adder fa (
                .a(pp[i+1][j]),
                .b(pp[i][j+1]),
                .cin(carry[i][j-1]),
                .sum(sum[i][j]),
                .cout(carry[i][j])
            );
        end
        assign {carry[i][7], sum[i][7]} = pp[i+1][7] + carry[i][6];
    end
endgenerate

assign product[1] = sum[0][0];
generate
    for (i = 0; i < 6; i = i + 1) begin
        assign product[i+2] = sum[i][i+1] + carry[i][i];
    end
endgenerate

assign product[14:8] = carry[6];

endmodule

module full_adder(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
    );

assign {cout, sum} = a + b + cin;

endmodule