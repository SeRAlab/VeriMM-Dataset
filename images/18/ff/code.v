module encoder_8to3 (  
    input [7:0] in,  
    output reg [2:0] out  
);  
    always @(*) begin  
        casez (in)  
            8'b1??????? : out = 3'b111; // Input 0 is active  
            8'b01?????? : out = 3'b110; // Input 1 is active  
            8'b001????? : out = 3'b101; // Input 2 is active  
            8'b0001???? : out = 3'b100; // Input 3 is active  
            8'b00001??? : out = 3'b011; // Input 4 is active  
            8'b000001?? : out = 3'b010; // Input 5 is active  
            8'b0000001? : out = 3'b001; // Input 6 is active  
            8'b00000001 : out = 3'b000; // Input 7 is active  
            default: out = 3'b111; // No input is active  
        endcase  
    end  
endmodule