module flash_memory (
    input clk,
    input [0:0] data_in,          // Input data to write (1-bit)
    input write_enable,           // Enable writing
    input read_enable,            // Enable reading
    output reg [0:0] data_out     // Output data read (1-bit)
);
    reg [0:0] memory;              // Memory storage

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in;     // Write data to memory
        end
        if (read_enable) begin
            data_out <= memory;    // Output data from memory
        end
    end
endmodule