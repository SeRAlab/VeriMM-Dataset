module reg_file_16bit(
    input wire clk,
    input wire we,
    input wire [2:0] wr_addr,
    input wire [15:0] wr_data,
    input wire [2:0] rd_addr1,
    input wire [2:0] rd_addr2,
    output wire [15:0] rd_data1,
    output wire [15:0] rd_data2
    );

reg [15:0] reg_file [7:0];
integer i;

// Write operation
always @(posedge clk) begin
    if (we) begin
        reg_file[wr_addr] <= wr_data;
    end
end

// Read operations
assign rd_data1 = reg_file[rd_addr1];
assign rd_data2 = reg_file[rd_addr2];

endmodule