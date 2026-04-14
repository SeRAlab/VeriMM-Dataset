module reg_file_32bit(
    input wire clk,
    input wire rst,
    input wire [2:0] read_addr1,
    input wire [2:0] read_addr2,
    input wire [2:0] write_addr,
    input wire [31:0] write_data,
    input wire write_en,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
    );

reg [31:0] reg_array [7:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_array[0] <= 32'b0;
        reg_array[1] <= 32'b0;
        reg_array[2] <= 32'b0;
        reg_array[3] <= 32'b0;
        reg_array[4] <= 32'b0;
        reg_array[5] <= 32'b0;
        reg_array[6] <= 32'b0;
        reg_array[7] <= 32'b0;
    end
    else if (write_en) begin
        reg_array[write_addr] <= write_data;
    end
end

always @(*) begin
    read_data1 = reg_array[read_addr1];
    read_data2 = reg_array[read_addr2];
end

endmodule