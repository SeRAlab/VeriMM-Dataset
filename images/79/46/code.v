module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] SUM,
    output COUT,
    output OVF
);wire [3:0] sum;
    wire [3:0] carry;
    wire [3:0] overflow;
    
    assign sum = A + B + CIN;
    assign carry = {CIN, sum[3:1]};
    assign COUT = carry[3];
    assign SUM = sum[3:0];
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin: overflow_block
            assign overflow[i] = (A[i] & B[i] & ~CIN) | (~A[i] & ~B[i] & CIN);
        end
    endgenerate
    
    assign OVF = |overflow;
    
endmodule