module top_module(A, B, SUB, SUM, CARRY);input [3:0] A;
input [3:0] B;
input SUB;
output reg [3:0] SUM; // Changed to reg to allow assignment in always block
output CARRY;

reg [3:0] twos_comp;
reg [4:0] temp_sum; // Changed to 5 bits to handle carry properly
reg carry;

always @(*) begin
    if(SUB == 1) begin
        twos_comp = ~B + 1;
        temp_sum = A + twos_comp;
        carry = temp_sum[4]; // Directly assign carry
        SUM = temp_sum[3:0];
    end
    else begin
        temp_sum = A + B;
        carry = temp_sum[4]; // Directly assign carry
        SUM = temp_sum[3:0];
    end
end

assign CARRY = carry;

endmodule