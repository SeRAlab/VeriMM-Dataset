module encoder_8to3(  
    input [7:0] in,  
    output reg [2:0] out  
);  
    always @(*) begin  
        casez (in)  
            8'b1??????? : out = 3'b111; // in7  
            8'b01?????? : out = 3'b110; // in6  
            8'b001????? : out = 3'b101; // in5  
            8'b0001???? : out = 3'b100; // in4  
            8'b00001??? : out = 3'b011; // in3  
            8'b000001?? : out = 3'b010; // in2  
            8'b0000001? : out = 3'b001; // in1  
            8'b00000001 : out = 3'b000; // in0  
            default: out = 3'b000;  
        endcase  
    end  
endmodule