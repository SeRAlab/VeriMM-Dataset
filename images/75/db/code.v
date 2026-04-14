module multiplier_4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] y
);
    wire [7:0] p[3:0]; // Partial products

    assign p[0] = b[0] ? {4'b0000, a} : 8'b00000000;
    assign p[1] = b[1] ? {3'b000, a, 1'b0} : 8'b00000000;
    assign p[2] = b[2] ? {2'b00, a, 2'b00} : 8'b00000000;
    assign p[3] = b[3] ? {1'b0, a, 3'b000} : 8'b00000000;

    assign y = p[0] + p[1] + p[2] + p[3];
endmodule