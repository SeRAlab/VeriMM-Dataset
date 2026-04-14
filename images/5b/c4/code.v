module top_module(input [3:0] num, output [7:0] seg);reg [7:0] tseg;
    always @(num) begin
        case (num)
            4'b0000: tseg = 8'b11111100; 
            4'b0001: tseg = 8'b01100000; 
            4'b0010: tseg = 8'b01011010; 
            4'b0011: tseg = 8'b11110010; 
            4'b0100: tseg = 8'b01100110; 
            4'b0101: tseg = 8'b10110110; 
            4'b0110: tseg = 8'b10111110; 
            4'b0111: tseg = 8'b11100100; 
            4'b1000: tseg = 8'b11111110; 
            4'b1001: tseg = 8'b11110110; 
            default: tseg = 8'b00000000; 
        endcase
        
    end
    assign seg = tseg;
endmodule