module dram_cell (
    input wire [7:0] data_in,
    input wire write_enable,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory <= data_in; // Write data
        end
    end

    always @(negedge write_enable) begin
        data_out <= memory; // Read data
    end
endmodule