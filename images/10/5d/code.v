module pcie_address_decoder(  
    input [31:0] address,  
    output reg [3:0] range  
);  
    always @(*) begin  
        case (address[31:28])  
            4'b0000: range = 4'b0000; // Range 0  
            4'b0001: range = 4'b0001; // Range 1  
            4'b0010: range = 4'b0010; // Range 2  
            4'b0011: range = 4'b0011; // Range 3  
            4'b0100: range = 4'b0100; // Range 4  
            4'b0101: range = 4'b0101; // Range 5  
            4'b0110: range = 4'b0110; // Range 6  
            4'b0111: range = 4'b0111; // Range 7  
            4'b1000: range = 4'b1000; // Range 8  
            4'b1001: range = 4'b1001; // Range 9  
            4'b1010: range = 4'b1010; // Range 10  
            4'b1011: range = 4'b1011; // Range 11  
            4'b1100: range = 4'b1100; // Range 12  
            4'b1101: range = 4'b1101; // Range 13  
            4'b1110: range = 4'b1110; // Range 14  
            4'b1111: range = 4'b1111; // Range 15  
            default: range = 4'b0000; // Default case  
        endcase  
    end  
endmodule