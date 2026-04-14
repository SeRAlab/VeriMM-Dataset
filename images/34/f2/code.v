module priority_encoder(  
    input [3:0] I,  
    output reg [1:0] Y,  
    output reg V  
);  
    always @(*) begin  
        casez (I)  
            4'b1???: begin  
                Y = 2'b00;  
                V = 1;  
            end  
            4'b01??: begin  
                Y = 2'b01;  
                V = 1;  
            end  
            4'b001?: begin  
                Y = 2'b10;  
                V = 1;  
            end  
            4'b0001: begin  
                Y = 2'b11;  
                V = 1;  
            end  
            default: begin  
                Y = 2'b00;  
                V = 0;  
            end  
        endcase  
    end  
endmodule