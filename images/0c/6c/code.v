module eeprom (
    input wire clk,
    input wire we,
    input wire [3:0] addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    reg [7:0] memory [0:15]; // EEPROM memory with 16 addresses

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to memory
        end
        else begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule