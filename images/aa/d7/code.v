module top_module(A, B, sub, CK, Y, Cout);input [3:0] A, B;
input sub, CK;
output [3:0] Y;
output Cout;
reg [3:0] Y_reg;
wire [3:0] B_neg;
wire [3:0] B_sub;
wire [4:0] Y_add;

// Invert B and add 1 to obtain two's complement of B
assign B_neg = ~B + 1;

// Select either B or B_neg based on sub input
assign B_sub = (sub) ? B_neg : B;

// Add A and B_sub
assign Y_add = {1'b0, A} + {1'b0, B_sub};

// Register the sum/difference output
always @(posedge CK) begin
    Y_reg <= Y_add[3:0];
end

// Output the sum/difference and carry/borrow
assign Y = Y_reg;
assign Cout = Y_add[4];

endmodule