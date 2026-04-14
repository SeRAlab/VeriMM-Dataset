module top_module(
                     clk,
                     rst,
                     regwrite,
                     memtoreg,
                     aluresult,
                     read_memdata,
                     valid_read_memdata,
                     dest_reg,
                     
                     wb_regwrite,
                     wb_memtoreg,
                     wb_aluresult,
                     wb_read_memdata,
                     wb_dest_reg
                     );input                     clk;
input                     rst;
input                     regwrite;
input                     memtoreg;
input    [31:0]           aluresult;
input    [31:0]           read_memdata;
input                     valid_read_memdata;
input    [4:0]            dest_reg;
                     
output                     wb_regwrite;
output                     wb_memtoreg;
output   [31:0]            wb_aluresult;
output   [31:0]            wb_read_memdata;
output   [4:0]             wb_dest_reg;  

reg                     wb_regwrite;
reg                     wb_memtoreg;
reg   [31:0]            wb_aluresult;
reg   [31:0]            wb_read_memdata;
reg   [4:0]             wb_dest_reg;
          
always@(posedge clk)
begin
  if(rst)
    begin
      wb_regwrite<=1'b0;
      wb_memtoreg<=1'b0;
      wb_aluresult<=32'h0000;
      wb_read_memdata<=32'h0000;
      wb_dest_reg<=5'b00000;
    end
 else if(valid_read_memdata)
    begin
      wb_regwrite<=regwrite;
      wb_memtoreg<=memtoreg;
      wb_aluresult<=aluresult;
      wb_read_memdata<=read_memdata;
      wb_dest_reg<=dest_reg;
    end   
end
endmodule