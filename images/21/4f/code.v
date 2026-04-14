module SRT_Divider (  
    input [3:0] dividend,  
    input [3:0] divisor,  
    input start,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  
    reg [3:0] D;  
    reg [3:0] Q;  
    reg [3:0] R;  
    integer i;  

    always @(posedge start) begin  
        D = dividend;  
        Q = 0;  
        R = 0;  
        done = 0;  
        
        for (i = 3; i >= 0; i = i - 1) begin  
            R = {R[2:0], D[i]};  
            if (R >= divisor) begin  
                R = R - divisor;  
                Q = {Q[2:0], 1'b1};  
            end else begin  
                Q = {Q[2:0], 1'b0};  
            end  
        end  
        
        quotient = Q;  
        remainder = R;  
        done = 1;  
    end  
endmodule