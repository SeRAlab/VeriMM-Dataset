module reg_file (
    input clk,
    input wr_en,
    input [2:0] wr_addr,
    input [15:0] wr_data,
    input [2:0] rd_addr1,
    input [2:0] rd_addr2,
    output reg [15:0] rd_data1,
    output reg [15:0] rd_data2
);

reg [15:0] registers [0:7];

always @(posedge clk) begin
    if (wr_en) begin
        registers[wr_addr] <= wr_data;
    end
end

always @(*) begin
    rd_data1 = registers[rd_addr1];
    rd_data2 = registers[rd_addr2];
end

endmodule