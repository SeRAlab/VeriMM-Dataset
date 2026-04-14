module decoder3to8(  
    input [2:0] binary_in,  
    output reg [7:0] output_out  
);  
    always @(*) begin  
        case (binary_in)  
            3'b000: output_out = 8'b00000001;  
            3'b001: output_out = 8'b00000010;  
            3'b010: output_out = 8'b00000100;  
            3'b011: output_out = 8'b00001000;  
            3'b100: output_out = 8'b00010000;  
            3'b101: output_out = 8'b00100000;  
            3'b110: output_out = 8'b01000000;  
            3'b111: output_out = 8'b10000000;  
            default: output_out = 8'b00000000;  
        endcase  
    end  
endmodule