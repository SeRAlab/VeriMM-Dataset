module encoder_4to2 (  
    input [3:0] I,  
    output reg [1:0] Y,  
    output reg V  
);  
    always @(*) begin  
        case (I)  
            4'b0000: begin  
                Y = 2'bxx;  
                V = 1'b0;  
            end  
            4'b0001: begin  
                Y = 2'b00;  
                V = 1'b1;  
            end  
            4'b0010: begin  
                Y = 2'b01;  
                V = 1'b1;  
            end  
            4'b0100: begin  
                Y = 2'b10;  
                V = 1'b1;  
            end  
            4'b1000: begin  
                Y = 2'b11;  
                V = 1'b1;  
            end  
            default: begin  
                Y = 2'bxx;  
                V = 1'b0;  
            end  
        endcase  
    end  
endmodule