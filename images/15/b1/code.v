module booth_multiplier (  
    input [4:0] A,  
    input [4:0] B,  
    output reg [9:0] P  
);  
    integer i;  
    reg [4:0] A_reg;  
    reg [4:0] B_reg;  
    reg [9:0] product;  
    reg [4:0] temp;  

    always @(*) begin  
        A_reg = A;  
        B_reg = B;  
        product = 10'b0;  
        
        for (i = 0; i < 5; i = i + 1) begin  
            if (B_reg[0] == 1) begin  
                product = product + (A_reg << i);  
            end  
            B_reg = B_reg >> 1;  
        end  
        P = product;  
    end  
endmodule