module reg_file_32x32(
    input wire clk,
    input wire we,
    input wire [4:0] wr_addr,
    input wire [31:0] wr_data,
    input wire [4:0] rd_addr1,
    input wire [4:0] rd_addr2,
    output reg [31:0] rd_data1,
    output reg [31:0] rd_data2
    );

reg [31:0] reg_file [31:0];

always @(posedge clk) begin
    if (we) begin
        reg_file[wr_addr] <= wr_data;
    end
end

always @(*) begin
    rd_data1 = reg_file[rd_addr1];
    rd_data2 = reg_file[rd_addr2];
end

endmodule