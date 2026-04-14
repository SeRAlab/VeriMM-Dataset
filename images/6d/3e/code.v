module top_module(
    input clk,
    input [7:0] addr,
    input [7:0] data_in,
    input write,
    output reg [7:0] data_out,
    output reg [7:0] led_out
    );reg [7:0] memory [0:256];

always @(posedge clk)
    begin
        if(write)
            begin
                memory[addr] <= data_in;
            end
        data_out <= memory[addr];
        led_out <= memory[8'b11111111];
    end
endmodule