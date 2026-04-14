module sram_cell (
    input [3:0] data_in,
    input [1:0] addr,
    input read_en,
    input write_en,
    output reg [3:0] data_out
);
    reg [3:0] memory [3:0]; // 4 x 4-bit memory cells

    always @(posedge write_en) begin
        if (write_en) begin
            memory[addr] <= data_in; // Write data to memory
        end
    end

    always @(posedge read_en) begin
        if (read_en) begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule