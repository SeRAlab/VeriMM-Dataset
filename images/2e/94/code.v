module booth_multiplier (  
    input signed [3:0] A,  
    input signed [3:0] B,  
    output reg signed [7:0] P  
);  
    reg [3:0] M;  
    reg [3:0] Q;  
    reg [2:0] Q_1;  
    reg [7:0] A_neg;  
    reg [7:0] P_temp;  
    integer i;  

    always @(*) begin  
        M = A;  
        Q = B;  
        Q_1 = 1'b0;  
        P_temp = 0;  
        for (i = 0; i < 4; i = i + 1) begin  
            case ({Q[0], Q_1})  
                2'b01: P_temp = P_temp + {4'b0, M};  
                2'b10: P_temp = P_temp - {4'b0, M};  
            endcase  
            {P_temp, Q} = {P_temp[7:0], Q[3:1]};  
            Q_1 = Q[0];  
            P_temp = P_temp >>> 1;  
        end  
        P = P_temp;  
    end  
endmodule