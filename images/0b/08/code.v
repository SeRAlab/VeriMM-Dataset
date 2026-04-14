module priority_encoder(input [3:0] I, output reg [1:0] Y);  
  always @(*) begin  
    casez (I)  
      4'b1??? : Y = 2'b11; // I3 is high  
      4'b01?? : Y = 2'b10; // I2 is high  
      4'b001? : Y = 2'b01; // I1 is high  
      4'b0001 : Y = 2'b00; // I0 is high  
      default : Y = 2'b00; // No input is high  
    endcase  
  end  
endmodule