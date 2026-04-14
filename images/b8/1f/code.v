module top_module(
    input clk,
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);reg [3:0] a_partial [2:0];
reg [3:0] b_partial [2:0];
reg [7:0] p_partial [2:0];
reg [3:0] a_final [3:0];
reg [3:0] b_final [3:0];
reg [7:0] p_final [3:0];

always @ (posedge clk) begin
    // Partial products
    a_partial[0] = {2'b0, A[1:0]}; // Correcting the selection order
    a_partial[1] = {2'b0, A[3:2]}; // Correcting the selection order
    a_partial[2] = 4'b0;
    b_partial[0] = {2'b0, B[1:0]}; // Correcting the selection order
    b_partial[1] = {2'b0, B[3:2]}; // Correcting the selection order
    b_partial[2] = 4'b0;
    p_partial[0] = a_partial[0] * b_partial[0];
    p_partial[1] = a_partial[1] * b_partial[1];
    p_partial[2] = a_partial[2] * b_partial[2];

    // Final products
    a_final[0] = A[0];
    a_final[1] = A[1];
    a_final[2] = A[2];
    a_final[3] = A[3];
    b_final[0] = B[0];
    b_final[1] = B[1];
    b_final[2] = B[2];
    b_final[3] = B[3];
    p_final[0] = p_partial[0];
    p_final[1] = p_partial[1] + (p_partial[0] >> 2);
    p_final[2] = p_partial[2] + (p_partial[1] >> 2) + (p_partial[0] >> 4);
    p_final[3] = (p_partial[2] >> 2) + (p_partial[1] >> 4) + (p_partial[0] >> 6);

    // Final product
    P = {p_final[3], p_final[2][1:0], p_final[1][2:0], p_final[0][3:0]};
end

endmodule