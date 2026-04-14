module barrel_shifter(  
    input [1:0] DATA,  
    input DIR,  
    output reg [1:0] RESULT  
);  
    always @(*) begin  
        case (DIR)  
            1'b0: RESULT = DATA << 1; // Left shift  
            1'b1: RESULT = DATA >> 1; // Right shift  
            default: RESULT = 2'b00;  
        endcase  
    end  
endmodule