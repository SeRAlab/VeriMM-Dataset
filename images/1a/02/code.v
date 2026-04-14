module booth_multiplier (  
    input signed [7:0] A,  
    input signed [7:0] B,  
    output reg signed [15:0] P  
);  
    integer i;  
    reg [7:0] M;  
    reg [7:0] Q;  
    reg Qn;  
    reg [15:0] A_reg;  
    reg [15:0] P_temp;  
     
    always @(*) begin  
        M = A;  
        Q = B;  
        Qn = 0;  
        A_reg = 0;  
        P_temp = {A_reg, Q};  
         
        for (i = 0; i < 8; i = i + 1) begin  
            case ({Q[0], Qn})  
                2'b01: P_temp = P_temp + {M, 8'b0};  
                2'b10: P_temp = P_temp - {M, 8'b0};  
            endcase  
            Qn = Q[0];  
            Q = {P_temp[0], Q[7:1]};  
            P_temp = {P_temp[15], P_temp[15:1]};  
        end  
         
        P = P_temp;  
    end  
endmodule