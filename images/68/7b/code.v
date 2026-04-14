module top_module(
    input clk,
    input [3:0] a_addr, a_din, b_addr, b_din,
    input a_wen, b_wen,
    output reg [3:0] a_dout, b_dout
);reg [3:0] memory [10:35];

    always @(posedge clk) begin
        if (a_wen)
            memory[10 + a_addr] <= a_din;
        a_dout <= memory[10 + a_addr];
    end

    always @(posedge clk) begin
        if (b_wen && (10 + a_addr != 20 + b_addr || !a_wen))
            memory[20 + b_addr] <= b_din;
        b_dout <= memory[20 + b_addr];
    end
endmodule