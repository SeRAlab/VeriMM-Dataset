module voltage_sensor(input [4:0] voltage, output reg is_high);  
  parameter THRESHOLD = 5'b01111;  
  always @(*) begin  
    if (voltage > THRESHOLD)  
      is_high = 1'b1;  
    else  
      is_high = 1'b0;  
  end  
endmodule