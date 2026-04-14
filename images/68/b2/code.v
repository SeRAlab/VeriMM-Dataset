module top_module(
    input [3:0] A,
    input [3:0] B,
    input C_in,
    input C_out,
    output reg [3:0] S,
    output reg C
);wire [3:0] sum;
    wire [3:0] carry;

    assign sum = A + B + C_in;
    assign carry = (A[3] & B[3]) | (A[3] & C_in) | (B[3] & C_in);

    assign C = C_out ? carry[3] : 0;
    always @(*) begin
        if(C_out) begin
            S = {carry[2:0], sum[3]};
        end else begin
            S = sum;
        end
    end

endmodule