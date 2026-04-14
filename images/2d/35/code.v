module priority_encoder_16_to_4 (  
    input [15:0] I,  
    output reg [3:0] Y,  
    output reg valid  
);  
    always @(*) begin  
        valid = 1'b0;  
        casez (I)  
            16'b1??????????????? : begin Y = 4'd0; valid = 1'b1; end  
            16'b01?????????????? : begin Y = 4'd1; valid = 1'b1; end  
            16'b001????????????? : begin Y = 4'd2; valid = 1'b1; end  
            16'b0001???????????? : begin Y = 4'd3; valid = 1'b1; end  
            16'b00001??????????? : begin Y = 4'd4; valid = 1'b1; end  
            16'b000001?????????? : begin Y = 4'd5; valid = 1'b1; end  
            16'b0000001????????? : begin Y = 4'd6; valid = 1'b1; end  
            16'b00000001???????? : begin Y = 4'd7; valid = 1'b1; end  
            16'b000000001??????? : begin Y = 4'd8; valid = 1'b1; end  
            16'b0000000001?????? : begin Y = 4'd9; valid = 1'b1; end  
            16'b00000000001????? : begin Y = 4'd10; valid = 1'b1; end  
            16'b000000000001???? : begin Y = 4'd11; valid = 1'b1; end  
            16'b0000000000001??? : begin Y = 4'd12; valid = 1'b1; end  
            16'b00000000000001?? : begin Y = 4'd13; valid = 1'b1; end  
            16'b000000000000001? : begin Y = 4'd14; valid = 1'b1; end  
            default: begin Y = 4'b1111; valid = 1'b0; end  
        endcase  
    end  
endmodule