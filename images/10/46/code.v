module SRAM (
    input wire [2:0] addr,       // 3-bit address for 8 locations
    input wire [7:0] data_in,    // 8-bit data input
    input wire we,               // Write enable
    output reg [7:0] data_out    // 8-bit data output
);
    reg [7:0] memory [7:0];      // 8 locations of 8-bit memory

    always @(posedge we) begin
        if (we) begin              // Write operation
            memory[addr] <= data_in;
        end
    end

    always @(negedge we) begin
        data_out <= memory[addr]; // Read operation
    end
endmodule