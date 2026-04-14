module top_module(output reg [7:0] z,
    input a,
    input [2:0]sel);always @*
    
    case(sel)
      3'b000 : z = {7'b0000000,a};
      3'b001 : z = {6'b000000,a,1'b0};
      3'b010 : z = {5'b00000,a,2'b00};
      3'b011 : z = {4'b0000,a,3'b000};
      3'b100 : z = {3'b000,a,4'b0000};
      3'b101 : z = {2'b00,a,5'b00000};
      3'b110 : z = {1'b0,a,6'b000000};
      3'b111 : z = {a,7'b0000000};
    endcase
  endmodule