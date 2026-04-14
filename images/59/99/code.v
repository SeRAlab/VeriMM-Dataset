module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [3:0] read_data
);reg [3:0] mem [7:0];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            mem[i] <= 4'b1111;
        end
    end else begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
end

always @(*) begin
    if (read_en) begin
        read_data = mem[read_addr];
    end else begin
        read_data = 4'b1111;
    end
end

endmodule