module SRAM (
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire we,
    input wire clk,
    input wire [3:0] addr
);
    reg [15:0] memory [0:15]; // 16 16-bit memory locations

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data
        end
        else begin
            data_out <= memory[addr]; // Read data
        end
    end
endmodule