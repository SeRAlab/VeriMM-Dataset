module dram_cell (
    input wire [3:0] data_in,
    input wire read,
    input wire write,
    output reg [3:0] data_out
);

    reg [3:0] memory;

    always @(posedge write) begin
        memory <= data_in; // Write data to memory
    end

    always @(posedge read) begin
        data_out <= memory; // Read data from memory
    end

endmodule