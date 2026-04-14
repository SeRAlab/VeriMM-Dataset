module decoder_2_to_4 (  
    input wire A1,  
    input wire A0,  
    output reg Y3,  
    output reg Y2,  
    output reg Y1,  
    output reg Y0  
);  
    always @(*) begin  
        case ({A1, A0})  
            2'b00: begin  
                Y3 = 0;  
                Y2 = 0;  
                Y1 = 0;  
                Y0 = 1;  
            end  
            2'b01: begin  
                Y3 = 0;  
                Y2 = 0;  
                Y1 = 1;  
                Y0 = 0;  
            end  
            2'b10: begin  
                Y3 = 0;  
                Y2 = 1;  
                Y1 = 0;  
                Y0 = 0;  
            end  
            2'b11: begin  
                Y3 = 1;  
                Y2 = 0;  
                Y1 = 0;  
                Y0 = 0;  
            end  
            default: begin  
                Y3 = 0;  
                Y2 = 0;  
                Y1 = 0;  
                Y0 = 0;  
            end  
        endcase  
    end  
endmodule