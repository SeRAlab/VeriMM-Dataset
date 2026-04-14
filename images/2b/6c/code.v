module sram_16bit (
    input wire clk,
    input wire [3:0] addr,
    input wire [15:0] data_in,
    input wire we,  // Write Enable
    input wire re,  // Read Enable
    output reg [15:0] data_out
);
    reg [15:0] memory [15:0];  // 16 x 16-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in;  // Write operation
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= memory[addr];  // Read operation
        end
    end
endmodule