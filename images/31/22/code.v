module SRAM_16bit (
    input wire [15:0] data_in,
    input wire [3:0] addr,
    input wire read_en,
    input wire write_en,
    output reg [15:0] data_out
);
    reg [15:0] memory [15:0]; // 16 words of 16 bits each

    always @(posedge write_en) begin
        if (write_en) begin
            memory[addr] <= data_in; // write data to memory
        end
    end

    always @(posedge read_en) begin
        if (read_en) begin
            data_out <= memory[addr]; // read data from memory
        end
    end
endmodule