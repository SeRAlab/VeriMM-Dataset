module sram_cell (
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire read_en,
    input wire write_en,
    input wire clk
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (write_en) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule