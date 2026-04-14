module audio_mixer(  
    input [7:0] A,  
    input [7:0] B,  
    input control,  
    output reg [7:0] Y  
);  
    always @(*) begin  
        if (control == 1'b0) begin  
            Y = A + B;  
        end else begin  
            Y = A - B;  
        end  
        
        // Clamp the output to 8 bits  
        if (Y > 8'd255)  
            Y = 8'd255;  
        else if (Y < 8'd0)  
            Y = 8'd0;  
    end  
endmodule