module top_module(
    input clk,
    input rst_n,
    input [1:0] write_en_0,
    input [3:0] write_addr_0,
    input [15:0] write_data_0,
    input [1:0] write_en_1,
    input [3:0] write_addr_1,
    input [15:0] write_data_1,
    input [1:0] read_en_0,
    input [3:0] read_addr_0,
    output reg [15:0] read_data_0,
    input [1:0] read_en_1,
    input [3:0] read_addr_1,
    output reg [15:0] read_data_1
);reg [15:0] mem [0:15];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data_0 <= 16'b0;
        read_data_1 <= 16'b0;
    end else begin
        if (write_en_0) begin
            mem[write_addr_0] <= write_data_0;
        end

        if (write_en_1) begin
            mem[write_addr_1] <= write_data_1;
        end

        if (read_en_0) begin
            read_data_0 <= mem[read_addr_0];
        end

        if (read_en_1) begin
            read_data_1 <= mem[read_addr_1];
        end
    end
end

endmodule