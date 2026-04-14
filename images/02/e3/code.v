module priority_encoder(  
    input [4:0] in,  
    output reg [2:0] out,  
    output reg valid  
);  
    always @* begin  
        valid = 1'b0;  
        casez(in)  
            5'b1????: begin out = 3'd4; valid = 1'b1; end  
            5'b01???: begin out = 3'd3; valid = 1'b1; end  
            5'b001??: begin out = 3'd2; valid = 1'b1; end  
            5'b0001?: begin out = 3'd1; valid = 1'b1; end  
            5'b00001: begin out = 3'd0; valid = 1'b1; end  
            default: begin out = 3'd0; valid = 1'b0; end  
        endcase  
    end  
endmodule