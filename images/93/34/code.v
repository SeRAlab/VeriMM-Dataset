module top_module(
    input [3:0] A,
    input [1:0] B,
    output reg [2:0] C
);// Shift left by 1
wire [4:0] A_shift_left = {1'b0, A};
wire [2:0] C_shift_left = A_shift_left[3:1];
// Shift right by 1
wire [4:0] A_shift_right = {A[3], A};
wire [2:0] C_shift_right = A_shift_right[3:1];
// Add 1
wire [4:0] A_add_one = {1'b0, A} + 1;
wire [2:0] C_add_one = A_add_one[3:1];
// Subtract 1
wire [4:0] A_sub_one = {1'b0, A} - 1;
wire [2:0] C_sub_one = A_sub_one[3:1];

// Assign output based on B
always @(*) begin
    case(B)
        2'b00: C = C_shift_left;
        2'b01: C = C_shift_right;
        2'b10: C = C_add_one;
        2'b11: C = C_sub_one;
    endcase
end

endmodule