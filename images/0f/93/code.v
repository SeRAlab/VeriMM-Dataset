module sram_4bit (
    input wire [3:0] data_in,
    input wire [1:0] addr,
    input wire read_en,
    input wire write_en,
    output reg [3:0] data_out
);
    reg [3:0] memory [3:0]; // 4x4-bit SRAM memory

    always @(posedge write_en) begin
        memory[addr] <= data_in; // Write data to memory
    end

    always @(posedge read_en) begin
        data_out <= memory[addr]; // Read data from memory
    end
endmodule