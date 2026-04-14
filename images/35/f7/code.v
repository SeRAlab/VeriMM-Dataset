module sram_cell (
    input wire [7:0] data_in,
    input wire control, // 1 for write, 0 for read
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge control) begin
        memory <= data_in; // Write data
    end

    always @(negedge control) begin
        data_out <= memory; // Read data
    end
endmodule