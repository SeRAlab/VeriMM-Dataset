module top_module(Clk,reset,Write_Reg,R_Addr_A,R_Addr_B,W_Addr,W_Data,R_Data_A,R_Data_B);parameter ADDR = 4;
    parameter NUM = 31;
    parameter SIZE = 31;
    
    input Clk;
    input reset;
    input Write_Reg;
    input [ADDR:0]R_Addr_A;
    input [ADDR:0]R_Addr_B;
    input [ADDR:0]W_Addr;
    input [SIZE:0]W_Data;
    
    output [SIZE:0]R_Data_A;
    output [SIZE:0]R_Data_B;
    
    reg [SIZE:0]REG_Files[0:NUM];
    integer i;
    
    always@(posedge Clk)
    begin
        if(reset)
                for(i=0;i<=NUM;i=i+1) REG_Files[i]<=0;
        else
		     if(W_Addr != 0) 
			     begin 
			       if(Write_Reg) REG_Files[W_Addr]<=W_Data;
			     end 
                
    end
    
    
    assign R_Data_A=REG_Files[R_Addr_A];
    assign R_Data_B=REG_Files[R_Addr_B];

endmodule