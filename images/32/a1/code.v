module sram_cell (
    input wire [3:0] data,
    input wire we,
    input wire re,
    input wire clk,
    output reg [3:0] q
);
    
    reg [3:0] memory;

    always @(posedge clk or negedge we) begin
        if (!we)
            memory <= 4'b0000; // Initialize on reset
        else if (we)
            memory <= data; // Write data to memory
    end

    always @(posedge clk) begin
        if (re)
            q <= memory; // Read data from memory
    end

endmodule