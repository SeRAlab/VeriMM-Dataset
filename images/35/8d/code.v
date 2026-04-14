module flash_memory_cell(
    input wire clk,
    input wire [7:0] data_in,
    input wire write_enable,
    input wire read_enable,
    input wire erase,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (erase) begin
            memory <= 8'b00000000; // Reset memory to default state
        end else if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule