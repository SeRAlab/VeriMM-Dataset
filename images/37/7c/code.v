module merge_sort_4bit(input [3:0] arr, output reg [3:0] sorted);  
    always @(*) begin  
        case (arr)  
            4'b0000: sorted = 4'b0000;  
            4'b0001: sorted = 4'b0001;  
            4'b0010: sorted = 4'b0010;  
            4'b0011: sorted = 4'b0011;  
            4'b0100: sorted = 4'b0100;  
            4'b0101: sorted = 4'b0101;  
            4'b0110: sorted = 4'b0110;  
            4'b0111: sorted = 4'b0111;  
            4'b1000: sorted = 4'b1000;  
            4'b1001: sorted = 4'b1001;  
            4'b1010: sorted = 4'b1010;  
            4'b1011: sorted = 4'b1011;  
            4'b1100: sorted = 4'b1100;  
            4'b1101: sorted = 4'b1101;  
            4'b1110: sorted = 4'b1110;  
            4'b1111: sorted = 4'b1111;  
            default: sorted = 4'b0000;  
        endcase  
    end  
endmodule