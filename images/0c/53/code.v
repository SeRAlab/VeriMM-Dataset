module flash_memory (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire read_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory_cell;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory_cell <= 8'b0; // Initialize to 0
            data_out <= 8'b0;
        end else if (write_enable) begin
            memory_cell <= data_in; // Write data to memory cell
        end else if (read_enable) begin
            data_out <= memory_cell; // Read data from memory cell
        end
    end
endmodule