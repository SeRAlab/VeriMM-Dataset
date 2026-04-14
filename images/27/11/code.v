module flash_memory (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire write_en,
    input wire erase_en,
    input wire read_en,
    output reg [7:0] data_out
);

    reg [7:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 8'b0; // Initialize memory on reset
            data_out <= 8'b0; // Clear output
        end else begin
            if (erase_en) begin
                memory <= 8'b0; // Erase the memory
            end else if (write_en) begin
                memory <= data_in; // Write data to memory
            end else if (read_en) begin
                data_out <= memory; // Read data from memory
            end
        end
    end
endmodule