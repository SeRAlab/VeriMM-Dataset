module eeprom_cell (
    input wire clk,
    input wire [0:0] data_in,
    input wire read_en,
    input wire write_en,
    input wire erase_en,
    output reg [0:0] data_out
);
    reg [0:0] memory;

    always @(posedge clk) begin
        if (erase_en) begin
            memory <= 1'b0; // Erase memory to 0
        end else if (write_en) begin
            memory <= data_in; // Write input data to memory
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            data_out <= memory; // Output memory data
        end
    end
endmodule