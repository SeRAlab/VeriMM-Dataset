module top_module(
         PCSrc, if_id_rs_addr, if_id_rt_addr,
         id_ex_RegWrite, id_ex_MemRead, id_ex_write_addr,
         ex_mem_MemRead, ex_mem_write_addr,
         DataHazard
       );input [2:0] PCSrc;
input [4:0] if_id_rs_addr;
input [4:0] if_id_rt_addr;
input id_ex_RegWrite;
input id_ex_MemRead;
input [4:0] id_ex_write_addr;
input ex_mem_MemRead;
input [4:0] ex_mem_write_addr;
output DataHazard;

wire last =
     id_ex_write_addr != 0 &&
     (if_id_rs_addr == id_ex_write_addr || if_id_rt_addr == id_ex_write_addr);
wire second_last =
     ex_mem_write_addr != 0 &&
     (if_id_rs_addr == ex_mem_write_addr || if_id_rt_addr == ex_mem_write_addr);
wire lw = id_ex_MemRead && last;
wire jr =
     PCSrc == 3'b010 && 
     
     ((id_ex_RegWrite && last) ||
      
      (ex_mem_MemRead && second_last)
      
      
     );

assign DataHazard = lw || jr;

endmodule