module top_module(
    
    RegWriteM,
    MemtoRegM,
    MemWriteM,
    ALUDataM,
    WriteDataM,
    WriteRegM,
    mem_data_i,
    
    RegWriteM_o,
    WriteRegData,
    WriteRegAddr,
    mem_addr,
    mem_we,
    mem_wd
);input RegWriteM;
input MemtoRegM;
input MemWriteM;
input [31:0] ALUDataM;
input [31:0] WriteDataM;
input [4:0] WriteRegM;
input [31:0] mem_data_i;

output RegWriteM_o;
output [31:0] WriteRegData;
output [4:0] WriteRegAddr;
output [31:0] mem_addr;
output mem_we;
output [31:0] mem_wd;

assign RegWriteM_o = RegWriteM;
assign WriteRegData = (MemtoRegM == 1'b1) ? mem_data_i : ALUDataM;
assign WriteRegAddr = WriteRegM;
assign mem_addr = ALUDataM;
assign mem_we = MemWriteM;
assign mem_wd = WriteDataM;

endmodule