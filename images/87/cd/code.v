module top_module(input [31:0] IN1,IN2,input IR_CU,output [31:0] OUT);assign OUT = IR_CU ? IN2 : IN1 ; 
endmodule