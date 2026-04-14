module top_module(A, B, C, S);input [3:0] A, B;
    input C;
    output reg [3:0] S;
    
    always @ (A or B or C) begin
        S = A + B + C;
        if (S > 15) begin
            S = 15;
        end
        else if (S < 0) begin
            S = 0;
        end
    end
    
endmodule