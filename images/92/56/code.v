module reg_file_16x8(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [2:0] read_addr1,
    input wire [2:0] read_addr2,
    input wire [2:0] write_addr,
    input wire [15:0] write_data,
    output wire [15:0] read_data1,
    output wire [15:0] read_data2
    );

reg [15:0] reg_array [0:7];
integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 8; i = i + 1) begin
            reg_array[i] <= 16'b0;
        end
    end
    else if (we) begin
        reg_array[write_addr] <= write_data;
    end
end

assign read_data1 = reg_array[read_addr1];
assign read_data2 = reg_array[read_addr2];

endmodule