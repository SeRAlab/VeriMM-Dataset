module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output signed [7:0] Z
);wire signed [7:0] product;
    reg signed [8:0] partial;
    reg [1:0] bit_pair;
    integer i;

    assign product = A * B;

    always @(*) begin
        if (B[0] == 0 && bit_pair == 2'b01) begin
            partial = partial - A;
        end else if (B[0] == 1 && bit_pair == 2'b10) begin
            partial = partial + A;
        end
        bit_pair <= {B[0], B[1]};
        partial = partial >> 1;
    end

    assign Z = partial[7:0];

endmodule