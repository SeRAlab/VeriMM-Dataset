module flash_memory (
    input wire [4:0] data_in,
    input wire write_enable,
    input wire erase,
    input wire clk,
    output reg [4:0] data_out
);

reg [4:0] memory;

// Write operation
always @(posedge clk) begin
    if (erase) begin
        memory <= 5'b00000; // Erase operation sets memory to 0
    end else if (write_enable) begin
        memory <= data_in; // Write data to memory
    end
end

// Read operation
always @(posedge clk) begin
    data_out <= memory; // Output the stored data
end

endmodule