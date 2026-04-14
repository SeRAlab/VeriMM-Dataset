module top_module(
    input [1:0] A,
    input [1:0] B,
    output reg Z
);always @ (*) begin
        if(A[1] > B[1]) begin
            Z = 1;
        end else if(A[1] < B[1]) begin
            Z = -1;
        end else if(A[0] > B[0]) begin
            Z = 1;
        end else if(A[0] < B[0]) begin
            Z = -1;
        end else begin
            Z = 0;
        end
    end

endmodule