module SRAM_16bit (
    input wire clk,
    input wire enable,
    input wire [3:0] address,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 SRAM cells of 16 bits each

    always @(posedge clk) begin
        if (enable) begin
            memory[address] <= data_in;  // Write data to the selected cell
        end
    end

    always @(posedge clk) begin
        if (!enable) begin
            data_out <= memory[address];  // Read data from the selected cell
        end
    end
endmodule