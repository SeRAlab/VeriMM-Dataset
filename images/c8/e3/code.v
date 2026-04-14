module arithmetic_op(output reg [3:0] Y, input [3:0] A, input [3:0] B, input S);

    always @(*) begin
        Y = (S == 0) ? (A + B) : (A - B);
    end
    
endmodule