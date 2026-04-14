module top_module(baud_mode, baud_rate);input       [3:0] baud_mode;
output reg [19:0] baud_rate;


always@(*)
   case(baud_mode)
      
      4'b0000 : baud_rate = 20'd333_333; 
      4'b0001 : baud_rate = 20'd083_333; 
      4'b0010 : baud_rate = 20'd041_667; 
      4'b0011 : baud_rate = 20'd020_833; 
      4'b0100 : baud_rate = 20'd010_417; 
      4'b0101 : baud_rate = 20'd005_208; 
      4'b0110 : baud_rate = 20'd002_604; 
      4'b0111 : baud_rate = 20'd001_736; 
      4'b1000 : baud_rate = 20'd000_868; 
      4'b1001 : baud_rate = 20'd000_434; 
      4'b1010 : baud_rate = 20'd000_217; 
      default : baud_rate = 20'd000_109; 
   endcase

endmodule