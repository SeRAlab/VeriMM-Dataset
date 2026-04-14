module dram_cell (
    input wire clk,
    input wire rst,
    input wire we,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    
    reg [7:0] memory;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory <= 8'b0; // Reset the memory
        end else if (we) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (!we) begin
            data_out <= memory; // Read data from memory
        end
    end

endmodule