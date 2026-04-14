module SRAM_Cell(
    input wire [7:0] data_in,
    input wire write_en,
    input wire read_en,
    input wire addr,
    output reg [7:0] data_out
);
    reg [7:0] memory [1:0]; // 2 locations for simplicity

    always @(posedge write_en) begin
        memory[addr] <= data_in; // Write data to memory at address
    end

    always @(posedge read_en) begin
        data_out <= memory[addr]; // Read data from memory at address
    end
endmodule