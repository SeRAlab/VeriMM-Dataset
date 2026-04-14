module reg_file_32bit_8reg (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [31:0] write_data,
    input [2:0] read_addr1,
    input [2:0] read_addr2,
    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] reg_file [7:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_file[0] <= 32'b0;
        reg_file[1] <= 32'b0;
        reg_file[2] <= 32'b0;
        reg_file[3] <= 32'b0;
        reg_file[4] <= 32'b0;
        reg_file[5] <= 32'b0;
        reg_file[6] <= 32'b0;
        reg_file[7] <= 32'b0;
    end else if (write_en) begin
        reg_file[write_addr] <= write_data;
    end
end

assign read_data1 = reg_file[read_addr1];
assign read_data2 = reg_file[read_addr2];

endmodule