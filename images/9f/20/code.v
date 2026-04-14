module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
wire [3:0] carry;

//Full Adder
//sum = A xor B xor Cin
//carry = (A and B) or (Cin and (A xor B))
assign sum = A ^ B ^ Cin;
assign carry = (A & B) | (Cin & (A ^ B));

//4-bit Ripple Carry Adder
//S = A + B + Cin
//Cout = carry[3]
assign S = sum;
assign Cout = carry[3];

//Propagate carry
//carry[i] = carry[i-1] & carry[i-2] & carry[i-3] & carry[i-4]
genvar i;
generate
    for(i=1; i<4; i=i+1) begin : carry_propagation
        assign carry[i] = carry[i-1] & carry[i-2] & carry[i-3] & carry[i-4];
    end
endgenerate

endmodule