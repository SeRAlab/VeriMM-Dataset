module dram_cell (
    input wire clk,
    input wire [3:0] addr,
    input wire [15:0] data_in,
    input wire read_en,
    input wire write_en,
    input wire enable,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 cells of 16 bits each

    always @(posedge clk) begin
        if (enable) begin
            if (write_en) begin
                memory[addr] <= data_in; // Write data to the selected address
            end
            if (read_en) begin
                data_out <= memory[addr]; // Read data from the selected address
            end
        end
    end
endmodule