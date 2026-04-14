module priority_encoder(  
    input [7:0] in,  
    output reg [2:0] out  
);  
    always @(*) begin  
        casez (in)  
            8'b1???????: out = 3'b111; // in[7]  
            8'b01??????: out = 3'b110; // in[6]  
            8'b001?????: out = 3'b101; // in[5]  
            8'b0001????: out = 3'b100; // in[4]  
            8'b00001???: out = 3'b011; // in[3]  
            8'b000001??: out = 3'b010; // in[2]  
            8'b0000001?: out = 3'b001; // in[1]  
            8'b00000001: out = 3'b000; // in[0]  
            default: out = 3'b000; // No input is active  
        endcase  
    end  
endmodule