module top_module(input clk, rst, flush,input [31:0] PC_In,input [2:0] PCSrc,input PCWrite,Branch,input [31:0] ConBA,DataBusA,input [25:0] JT,output reg [31:0] PC_Out);always @(posedge clk or posedge rst) begin 
  if (rst) begin 
  PC_Out <= 0; 
  end else if(flush) 
  PC_Out <= {PC_Out[31], {31{1'b0}}}; 
  else if (PCWrite) begin 
  if(Branch) begin 
  PC_Out <= ConBA; 
  end else case (PCSrc) 
  3'h0: PC_Out <= PC_In+32'h4; 
  3'h1: PC_Out <= PC_In+32'h4; 
  3'h2: PC_Out <= {PC_In[31:28], JT, 2'b0}; 
  3'h3: PC_Out <= DataBusA; 
  3'h4: PC_Out <= 32'h8000_0004; 
  3'h5: PC_Out <= 32'h8000_0008; 
  default: PC_Out <= 32'h8000_0008; 
  endcase 
  end else 
  PC_Out <= PC_Out; 
  end 
 endmodule