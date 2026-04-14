module booth_multiplier (  
    input [3:0] multiplicand,  
    input [3:0] multiplier,  
    output reg [7:0] product  
);  
    reg [4:0] M;  
    reg [4:0] Q;  
    reg [4:0] Q_1;  
    reg [4:0] A;  
    integer i;  

    always @(*) begin  
        M = {1'b0, multiplicand};  
        Q = {1'b0, multiplier};  
        Q_1 = 0;  
        A = 0;  
        product = 0;  

        for (i = 0; i < 4; i = i + 1) begin  
            case ({Q[0], Q_1})  
                2'b01: A = A + M;  
                2'b10: A = A - M;  
            endcase  
            {A, Q} = {A[4:0], Q[4:0]};  
            Q_1 = Q[0];  
            {A, Q} = {A[4:0], Q[4:0]} >> 1;  
        end  
        product = {A[3:0], Q[3:0]};  
    end  
endmodule