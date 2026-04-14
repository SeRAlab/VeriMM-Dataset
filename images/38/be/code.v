module sram_8bit (
    input wire we,           // Write enable
    input wire re,           // Read enable
    input wire [7:0] data_in, // Data input
    input wire [2:0] addr,     // Address input
    output reg [7:0] data_out  // Data output
);

    reg [7:0] memory [0:7]; // 8-bit memory locations

    always @(*) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end
    end

    always @(*) begin
        if (re) begin
            data_out <= memory[addr]; // Read operation
        end else begin
            data_out <= 8'bz; // High impedance when not reading
        end
    end
endmodule