module sram_cell (
    input [15:0] data_in,
    input [3:0] addr,
    input we,
    output reg [15:0] data_out
);

    reg [15:0] memory [15:0]; // 16 entries of 16-bit memory

    always @(posedge we) begin
        memory[addr] <= data_in; // Write data to memory when we is high
    end

    always @(negedge we) begin
        data_out <= memory[addr]; // Read data from memory when we is low
    end

endmodule