module SRAM_16bit (
    input wire [15:0] data_in,       // Input data
    input wire [3:0] address,        // Address input (4 bits for 16 locations)
    input wire we,                   // Write enable
    output reg [15:0] data_out       // Output data
);
    reg [15:0] memory [0:15];        // 16x16-bit memory array

    always @(posedge we) begin
        memory[address] <= data_in;   // Write operation
    end

    always @(*) begin
        data_out = memory[address];     // Read operation
    end
endmodule