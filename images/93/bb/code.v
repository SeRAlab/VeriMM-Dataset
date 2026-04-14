module reg_file_8x8(CLK, WE, WR_ADDR, WR_DATA, RD_ADDR1, RD_ADDR2, RD_DATA1, RD_DATA2);
input CLK;
input WE;
input [2:0] WR_ADDR;
input [7:0] WR_DATA;
input [2:0] RD_ADDR1;
input [2:0] RD_ADDR2;
output reg [7:0] RD_DATA1;
output reg [7:0] RD_DATA2;

reg [7:0] reg_file [7:0];

always @(posedge CLK) begin
    if (WE) begin
        reg_file[WR_ADDR] <= WR_DATA;
    end
end

always @(*) begin
    RD_DATA1 = reg_file[RD_ADDR1];
    RD_DATA2 = reg_file[RD_ADDR2];
end

endmodule