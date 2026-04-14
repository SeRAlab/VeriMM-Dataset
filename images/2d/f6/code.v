module sram_cell (
    input wire clk,
    input wire we,
    input wire [2:0] addr, // 3 bits for 8 addresses
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [7:0]; // 8 addresses of 8 bits each

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to memory
        end else begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule