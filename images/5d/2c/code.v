module top_module(input [3:0] A, input [3:0] B, output reg smaller);always @ (A,B)
begin 
    if (A[3:0] < B[3:0])
        smaller = 1'b1;
    else
        smaller = 1'b0;
end 
endmodule