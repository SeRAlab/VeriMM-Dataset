module top_module(sw, an);input [2:0] sw;       
output reg [7:0] an;       

 always @(sw[2:0])  begin
      case(sw[2:0])
      3'b000:an=~8'b00000001;
      3'b001:an=~8'b00000010;
      3'b010:an=~8'b00000100;
      3'b011:an=~8'b00001000;
      
      3'b100:an=~8'b00010000;
      3'b101:an=~8'b00100000;
      3'b110:an=~8'b01000000;
      3'b111:an=~8'b10000000;
      endcase
     end                                                                                                                                                                                          
endmodule