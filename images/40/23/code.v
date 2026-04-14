module divider_8bit (  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] Q,  
    output reg R  
);  
    always @(*) begin  
        if (B == 8'b0) begin  
            Q = 8'b0;  
            R = 1'b0;  
        end else begin  
            Q = A / B;  
            R = A % B;  
        end  
    end  
endmodule