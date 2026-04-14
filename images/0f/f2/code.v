module encoder_4_to_2 (  
    input wire [3:0] A,  
    output reg [1:0] Y,  
    output reg valid  
);  
    always @(*) begin  
        valid = 0;  
        case (A)  
            4'b0000: begin  
                Y = 2'b00;  
            end  
            4'b0001: begin  
                Y = 2'b00;  
                valid = 1;  
            end  
            4'b0010: begin  
                Y = 2'b01;  
                valid = 1;  
            end  
            4'b0100: begin  
                Y = 2'b10;  
                valid = 1;  
            end  
            4'b1000: begin  
                Y = 2'b11;  
                valid = 1;  
            end  
            default: begin  
                Y = 2'b00;  
            end  
        endcase  
    end  
endmodule