module top_module(
    input clk,
    input rst_n,
    input write_en_1,
    input [2:0] write_addr_1,
    input [3:0] write_data_1,
    input read_en_1,
    input [2:0] read_addr_1,
    output reg [3:0] read_data_1,
    input write_en_2,
    input [2:0] write_addr_2,
    input [3:0] write_data_2,
    input read_en_2,
    input [2:0] read_addr_2,
    output reg [3:0] read_data_2,
    output [3:0] final_output
);reg [3:0] ram1 [7:0];
reg [3:0] ram2 [7:0];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            ram1[i] <= 4'b0000;
            ram2[i] <= 4'b0000;
        end
    end else begin
        if (write_en_1) begin
            ram1[write_addr_1] <= write_data_1;
        end
        if (write_en_2) begin
            ram2[write_addr_2] <= write_data_2;
        end
    end
end

always @(posedge clk) begin
    if (read_en_1) begin
        read_data_1 <= ram1[read_addr_1];
    end
    if (read_en_2) begin
        read_data_2 <= ram2[read_addr_2];
    end
end

assign final_output = read_data_1 ^ read_data_2;

endmodule