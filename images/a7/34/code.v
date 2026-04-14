module top_module(
    input [3:0] A,
    input [3:0] B,
    input CLK,
    input RST,
    output reg [3:0] C
);wire [3:0] sum;
    wire [3:0] carry;

    // Output carry; initially set to 0
    assign carry[0] = 0;

    // Full adder implementation using behavioral model
    // Each bit's sum and carry are calculated
    assign sum[0] = A[0] ^ B[0] ^ carry[0];
    assign carry[1] = (A[0] & B[0]) | (carry[0] & (A[0] ^ B[0]));

    assign sum[1] = A[1] ^ B[1] ^ carry[1];
    assign carry[2] = (A[1] & B[1]) | (carry[1] & (A[1] ^ B[1]));

    assign sum[2] = A[2] ^ B[2] ^ carry[2];
    assign carry[3] = (A[2] & B[2]) | (carry[2] & (A[2] ^ B[2]));

    assign sum[3] = A[3] ^ B[3] ^ carry[3];
    wire final_carry = (A[3] & B[3]) | (carry[3] & (A[3] ^ B[3]));

    // Output is updated on the rising edge of the clock signal
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            C <= 0;
        end else begin
            C <= sum;
        end
    end

endmodule