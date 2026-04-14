module sram_4bit (
    input wire clk,
    input wire we,   // Write Enable
    input wire re,   // Read Enable
    input wire [3:0] data_in, // 4-bit Data Input
    output reg [3:0] data_out  // 4-bit Data Output
);
    reg [3:0] memory; // 4-bit memory storage

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule