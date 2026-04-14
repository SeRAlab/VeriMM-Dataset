module top_module( input      [4:0]  alu_ctl, 
             input      [31:0] a_in, b_in, 
             output reg [31:0] result, 
             output            zero_flag );assign zero_flag = (result == 0);
   
     always @(alu_ctl, a_in, b_in) begin         
          case (alu_ctl)
               0:  result = a_in & b_in;         
               1:  result = a_in | b_in;         
               2:  result = a_in + b_in;         
               6:  result = a_in - b_in;         
               7:  result = a_in < b_in ? 1 : 0; 
               8:  result = ~(a_in | b_in);      
               9:  result = a_in ^ b_in;         
               default: result = 0;
          endcase
     end
   
endmodule