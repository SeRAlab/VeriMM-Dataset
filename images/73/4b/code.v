module top_module(
    input [3:0] bcd_data,
    output reg [7:0] seg_data
);always @(bcd_data) begin
        case (bcd_data)
             4'b0000:    seg_data <= 8'b11000000;    
             4'b0001:    seg_data <= 8'b11111001;    
             4'b0010:    seg_data <= 8'b10100100;    
             4'b0011:    seg_data <= 8'b10110000;    
             4'b0100:    seg_data <= 8'b10011001;    
             4'b0101:    seg_data <= 8'b10010010;    
             4'b0110:    seg_data <= 8'b10000010;    
             4'b0111:    seg_data <= 8'b11111000;    
             4'b1000:    seg_data <= 8'b10000000;    
             4'b1001:    seg_data <= 8'b10010000;    
             4'b1010:    seg_data <= 8'b01111111;    
             default:    seg_data <= 8'b11111111;    
        endcase    
    end
    
endmodule