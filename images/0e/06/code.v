module sram_cell (
    input wire we,
    input wire [7:0] data_in,
    input wire [2:0] addr,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8x8-bit memory

    always @(posedge we) begin
        memory[addr] <= data_in; // Write data to the specified address
    end

    always @(*) begin
        data_out = memory[addr]; // Read data from the specified address
    end
endmodule