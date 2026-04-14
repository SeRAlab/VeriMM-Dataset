module top_module(taraddr,pcout,imm,npc_sel,zero,newpc,jal_ins);input [29:0] pcout;
  input [15:0] imm;
  input zero;
  input [1:0] npc_sel;
  
  input [25:0] taraddr;
  output [29:0] newpc;
  
  output [29:0] jal_ins;
  wire [29:0] temp1,temp2,temp3,temp4;
  
  
  
  assign temp1=pcout+1;
  
  
  
  assign temp2={{14{imm[15]}},imm};
  
  assign temp3=temp1+temp2;
  
  assign temp4={temp1[29:26],taraddr};
  
  assign jal_ins=temp4+1;
  
  
  
  
  assign newpc=(npc_sel==2'b01 && zero==1)?temp3:
                
               (npc_sel==2'b00)?temp1:
                
               (npc_sel==2'b01 && zero==0)?temp1:
               
               
               (npc_sel==2'b10)?temp4:
               (npc_sel==2'b11)?temp4:
                npc_sel;

endmodule