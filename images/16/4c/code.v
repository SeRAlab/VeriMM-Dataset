module SRAM (
    input wire clk,
    input wire enable,
    input wire [15:0] data_in,
    input wire [3:0] addr,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16x16 SRAM

    always @(posedge clk) begin
        if (enable) begin
            memory[addr] <= data_in; // Write operation
        end
    end
    
    always @(posedge clk) begin
        if (!enable) begin
            data_out <= memory[addr]; // Read operation
        end
    end
endmodule