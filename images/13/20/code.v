module booth_multiplier(  
    input signed [3:0] A,  
    input signed [3:0] B,  
    output reg signed [7:0] P  
);  
    integer i;  
    reg signed [7:0] A_ext;  
    reg signed [7:0] B_ext;  
    reg [4:0] Q;  
    reg Q_1;  

    always @(*) begin  
        A_ext = {A, 4'b0};  
        B_ext = {B, 4'b0};  
        Q = {4'b0, B[0]};  
        Q_1 = 0;  
        P = 0;  

        for (i = 0; i < 4; i = i + 1) begin  
            case ({Q[0], Q_1})  
                2'b01: P = P + A_ext;  
                2'b10: P = P - A_ext;  
            endcase  
            P = P >> 1;  
            Q_1 = Q[0];  
            Q = {P[0], Q[4:1]};  
        end  
    end  
endmodule