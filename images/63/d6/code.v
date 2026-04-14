module top_module(clk, write, ReadRegID1,ReadRegID2, WriteRegID, WriteData, ReadData1, ReadData2);input clk, write;
input [5:0] ReadRegID1,ReadRegID2, WriteRegID;
input [31:0] WriteData;
output reg [31:0]ReadData1, ReadData2;


reg [5:0] stt_cnt;
reg [31:0] data_ram[5:0]; 

always@(posedge clk)
    begin
        if (write && (WriteRegID < 6'b100000)) 
            begin
                data_ram[WriteRegID] = WriteData;
                
            end             
    end

always@(posedge clk)
    begin
        if (ReadRegID1 != 0)
            ReadData1 = data_ram[ReadRegID1];
        if (ReadRegID2 != 0)
            ReadData2 = data_ram[ReadRegID2];
    end
endmodule