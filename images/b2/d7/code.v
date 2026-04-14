module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    output reg [3:0] read_data,
    input [31:0] in,
    output [31:0] out
);// True Dual-Port RAM
reg [3:0] ram [0:7];
integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            ram[i] <= 4'b0000;
        end
    end else begin
        if (write_en) begin
            ram[write_addr[2:0]] <= write_data;
        end
        if (read_en) begin
            read_data <= ram[read_addr[2:0]];
        end
    end
end

// Byte-Reversing Module
wire [7:0] byte0, byte1, byte2, byte3;
assign byte0 = in[7:0];
assign byte1 = in[15:8];
assign byte2 = in[23:16];
assign byte3 = in[31:24];

wire [31:0] reversed;
assign reversed = {byte0, byte1, byte2, byte3};

// XOR Module
assign out = reversed ^ {read_data, read_data, read_data, read_data, read_data, read_data, read_data, read_data};

endmodule