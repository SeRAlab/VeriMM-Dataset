module sram_cell (
    input wire [3:0] addr,
    input wire we,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 x 16-bit memory

    always @(posedge we) begin
        if (we) begin
            memory[addr] <= data_in; // Write data
        end
    end

    always @(*) begin
        data_out = memory[addr]; // Read data
    end
endmodule