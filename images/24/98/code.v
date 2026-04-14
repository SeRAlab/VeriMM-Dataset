module booth_multiplier (  
    input signed [3:0] A,  
    input signed [3:0] B,  
    output reg signed [7:0] P  
);  
    reg signed [7:0] M;  
    reg signed [7:0] Q;  
    reg [3:0] Q1;  
    integer i;  
    
    always @(*) begin  
        M = {4'b0000, A};  
        Q = {4'b0000, B};  
        Q1 = 1'b0;  
        P = 0;  
        
        for (i = 0; i < 4; i = i + 1) begin  
            case ({Q[0], Q1})  
                2'b01: P = P + M;  
                2'b10: P = P - M;  
                default: ;  
            endcase  
            Q1 = Q[0];  
            Q = {P[7], Q[7:1]};  
            P = {P[6:0], Q[0]};  
        end  
    end  
endmodule