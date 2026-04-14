module top_module(
    input [3:0] number,
    output reg [7:0] seven_seg,
    input enable
);always @(*) begin
    seven_seg <= 8'hFF;
    if (enable)
    case (number)
      4'h0: seven_seg <= 8'b11000000; 
      4'h1: seven_seg <= 8'b11111001; 
      4'h2: seven_seg <= 8'b10100100; 
      4'h3: seven_seg <= 8'b10110000; 
      4'h4: seven_seg <= 8'b10011001; 
      4'h5: seven_seg <= 8'b10010010; 
      4'h6: seven_seg <= 8'b10000010; 
      4'h7: seven_seg <= 8'b11111000; 
      4'h8: seven_seg <= 8'b10000000; 
      4'h9: seven_seg <= 8'b10010000; 
      4'hA: seven_seg <= 8'b10001000; 
      4'hB: seven_seg <= 8'b10000011; 
      4'hC: seven_seg <= 8'b11000110; 
      4'hD: seven_seg <= 8'b10100001; 
      4'hE: seven_seg <= 8'b10000110; 
      4'hF: seven_seg <= 8'b10001110; 
      default: seven_seg <= 8'b00000000;
    endcase
end


endmodule