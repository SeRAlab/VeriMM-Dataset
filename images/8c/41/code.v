module top_module(
    input [3:0] a,
    input [3:0] b,
    input carry_in,
    output [3:0] sum,
    output carry_out
);reg [3:0] sum_reg;
reg carry_out_reg;

always @(*) begin
    sum_reg[0] = a[0] ^ b[0] ^ carry_in;
    sum_reg[1] = a[1] ^ b[1] ^ sum_reg[0];
    sum_reg[2] = a[2] ^ b[2] ^ sum_reg[1];
    sum_reg[3] = a[3] ^ b[3] ^ sum_reg[2];
    
    carry_out_reg = (a[3] & b[3]) | (a[3] & carry_in) | (b[3] & carry_in);
end

assign sum = sum_reg;
assign carry_out = carry_out_reg;

endmodule