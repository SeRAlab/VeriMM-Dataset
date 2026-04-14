module reg_file(
    input clk,
    input rst,
    input wr_en,
    input [2:0] wr_addr,
    input [15:0] wr_data,
    input [2:0] rd_addr1,
    input [2:0] rd_addr2,
    
    output [15:0] rd_data1,
    output [15:0] rd_data2
);

reg [15:0] registers [7:0];
integer i;

assign rd_data1 = registers[rd_addr1];
assign rd_data2 = registers[rd_addr2];

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        for (i = 0; i < 8; i = i + 1)
            registers[i] <= 16'b0;
    end
    else if (wr_en)
        registers[wr_addr] <= wr_data;
end

endmodule