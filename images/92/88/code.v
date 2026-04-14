module top_module(input clock,input resetn,input enable,output o_stall,input i_valid,input i_predicate,input [31:0] i_globalid0,input [31:0] i_increment,input i_stall,output reg o_valid,output reg [31:0] o_result,output avm_read,output avm_write,output [5:0] avm_burstcount,output [31:0] avm_address,output [255:0] avm_writedata,output [31:0] avm_byteenable,input avm_waitrequest,input [255:0] avm_readdata,input avm_readdatavalid,input avm_writeack);reg busy; 
 wire predicated_read; 
 wire down_stall; 
 assign down_stall = ( o_valid & i_stall ); 
 assign avm_read = ( i_valid & ~down_stall & ~busy & ~i_predicate); 
 assign avm_address = i_increment; 
 assign avm_write = 1'b0; 
 assign avm_writedata = 256'b0; 
 assign avm_byteenable = 32'b1; 
 assign avm_burstcount = 1; 
 assign predicated_read = ( i_valid & ~down_stall & ~busy & i_predicate ); 
  always @( posedge clock or negedge resetn ) begin 
  if( ~resetn ) begin 
  o_valid <= 1'b0; 
  busy <= 1'b0; 
  o_result <= 32'dx; 
  end 
  else begin 
  busy <= (busy & ~avm_readdatavalid) | (~busy & avm_read & ~avm_waitrequest); 
  if( ~down_stall ) 
  begin 
  o_valid <= avm_readdatavalid | predicated_read; 
  if( predicated_read ) begin 
  o_result <= 32'b0; 
  end 
  else begin 
  o_result <= avm_readdata[31:0]; 
  end 
  end 
  end 
 end 
 assign o_stall = ( down_stall | ( avm_read & avm_waitrequest ) | busy ); 
 endmodule