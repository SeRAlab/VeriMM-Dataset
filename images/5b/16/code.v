module top_module(A, B, P);input [3:0] A;
    input [3:0] B;
    output [7:0] P;
    wire [7:0] P_temp;
    
    assign P_temp = {A[0]&B, A[1]&B, A[2]&B, A[3]&B};
    assign P = {P_temp[0], P_temp[1], P_temp[2], P_temp[3], P_temp[4], P_temp[5], P_temp[6], P_temp[7]};
    
endmodule