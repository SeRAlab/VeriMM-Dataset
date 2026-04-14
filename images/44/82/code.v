module top_module(
    input clk,
    input ram_full_fb_i_reg,
    input tmp_ram_rd_en,
    input [11:0] Q,
    input [63:0] din,
    output reg [63:0] dout, // Changed to reg type
    input [0:0] out
);reg [63:0] memory [4096:0]; // 4096 locations, 64 bits each
    reg [11:0] address; // register to hold the memory address
    wire write_enable = ~ram_full_fb_i_reg & ~tmp_ram_rd_en; // enable write if memory is not full and not being read from

    always @(posedge clk) begin
        if (tmp_ram_rd_en) begin
            dout <= memory[Q]; // This assignment is now valid
        end else if (write_enable) begin
            memory[Q] <= din;
        end
    end

    assign out = ram_full_fb_i_reg & ~tmp_ram_rd_en; // set output signal high if memory is full and a write operation is attempted

endmodule