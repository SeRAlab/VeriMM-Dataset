module top_module(input IN1, IN2, IN3, IN4, output QN, input VDD, VSS);wire nand1, nand2, nand3;
  
  assign nand1 = ~(IN1 & IN2);
  assign nand2 = ~(IN3 & IN4);
  assign nand3 = ~(nand1 & nand2);
  
  assign QN = nand3;
endmodule