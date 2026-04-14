module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    output reg [3:0] read_data,
    input a,
    input b,
    output wire out_and_assign,
    output reg out_and_alwaysblock,
    output [7:0] ram_and_and_output
);reg [3:0] ram [7:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 4'b0000;
        out_and_alwaysblock <= 1'b0;
    end else begin
        if (write_en) begin
            ram[write_addr] <= write_data;
        end
        if (read_en) begin
            read_data <= ram[read_addr];
        end
        out_and_alwaysblock <= a & b;
    end
end

assign out_and_assign = a & b;

function [7:0] sum_ram;
    integer i;
    begin
        sum_ram = 8'b0;
        for (i = 0; i < 8; i = i + 1) begin
            sum_ram = sum_ram + ram[i];
        end
    end
endfunction

assign ram_and_and_output = sum_ram() + (out_and_assign ? 8'b1 : 8'b0);

endmodule