module sram_cell (
    input wire [15:0] data,
    input wire we,
    input wire re,
    output reg [15:0] q
);
    reg [15:0] memory;

    always @(posedge we or posedge re) begin
        if (we) begin
            memory <= data; // Write data to memory
        end
    end

    always @(posedge re) begin
        q <= memory; // Read data from memory
    end
endmodule