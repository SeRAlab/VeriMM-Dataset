module sram_cell (
    input wire clk,
    input wire enable,
    input wire rw, // read/write control: 1 for write, 0 for read
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (enable) begin
            if (rw) begin
                // Write data to memory
                memory <= data_in;
            end else begin
                // Read data from memory
                data_out <= memory;
            end
        end
    end
endmodule