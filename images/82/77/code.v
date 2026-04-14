module top_module(a, b, ci, out, co);parameter SIZE=8;
input [SIZE-1:0] a;
input [SIZE-1:0] b;
input ci;
output [SIZE-1:0] out;
output co;

wire [SIZE:0] c;
assign c[0] = ci;
assign co = c[SIZE];

genvar i;
generate for(i=0; i<SIZE; i=i+1) begin:addbit
    assign out[i] = a[i] ^ b[i] ^ c[i];
    assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
end endgenerate

endmodule