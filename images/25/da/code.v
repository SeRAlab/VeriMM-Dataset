module divider_4bit (  
    input [3:0] A,  
    input [3:0] B,  
    output reg [3:0] Q,  
    output reg [3:0] R  
);  
    always @(*) begin  
        if (B == 4'b0000) begin  
            Q = 4'b0000;  
            R = 4'b0000;  
        end else begin  
            Q = A / B;  
            R = A % B;  
        end  
    end  
endmodule