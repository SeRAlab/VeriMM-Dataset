module dram_cell (
    input wire clk,
    input wire [3:0] data_in,
    input wire read,
    input wire write,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (write) begin
            memory <= data_in; // Store data on write
        end
    end

    always @(posedge clk) begin
        if (read) begin
            data_out <= memory; // Output stored data on read
        end
    end
endmodule