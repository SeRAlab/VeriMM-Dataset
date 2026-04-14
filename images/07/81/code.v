module encoder_8to3 (  
    input [7:0] in,  
    output reg [2:0] out  
);  
    always @(*) begin  
        casez (in)  
            8'b1???????: out = 3'b111; // Input 7  
            8'b01??????: out = 3'b110; // Input 6  
            8'b001?????: out = 3'b101; // Input 5  
            8'b0001????: out = 3'b100; // Input 4  
            8'b00001???: out = 3'b011; // Input 3  
            8'b000001??: out = 3'b010; // Input 2  
            8'b0000001?: out = 3'b001; // Input 1  
            8'b00000001: out = 3'b000; // Input 0  
            default: out = 3'b111; // No active input  
        endcase  
    end  
endmodule