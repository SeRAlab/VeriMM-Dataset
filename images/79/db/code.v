module top_module(input clk,output led0,output led1,output led2,output led3,output led4,output led5);reg [25:0] counter; 
 reg [5:0] ledout; 
 assign {led0,led1,led2,led3,led4,led5}=6'b111111; 
 assign duty0=0; 
 assign duty1=counter[15]&counter[16]&counter[17]; 
 assign duty2=counter[15]&counter[16]; 
 assign duty3=counter[15]; 
 assign duty4=1; 
 always @(posedge clk) 
 begin 
  counter<=counter+1; 
  case (counter[25:23]) 
  3'b000:ledout={duty0,duty4,duty3,duty2,duty1,duty0}; 
  3'b001:ledout={duty4,duty3,duty2,duty1,duty0,duty0}; 
  3'b010:ledout={duty3,duty2,duty1,duty0,duty0,duty0}; 
  3'b011:ledout={duty2,duty1,duty0,duty0,duty0,duty0}; 
  3'b100:ledout={duty1,duty0,duty0,duty0,duty0,duty4}; 
  3'b101:ledout={duty0,duty0,duty0,duty0,duty4,duty3}; 
  3'b110:ledout={duty0,duty0,duty0,duty4,duty3,duty2}; 
  default:ledout={duty0,duty0,duty4,duty3,duty2,duty1}; 
  endcase 
 end 
 endmodule