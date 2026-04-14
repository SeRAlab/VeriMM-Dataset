module SRAM_4bit (
    input wire [3:0] data_in,
    input wire WE,
    input wire RE,
    input wire clk,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (WE) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (RE) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule