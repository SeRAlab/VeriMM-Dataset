module dram_cell (
    input wire [15:0] data_in,
    input wire write_en,
    output reg [15:0] data_out
);

    reg [15:0] memory;

    always @(posedge write_en) begin
        if (write_en) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(negedge write_en) begin
        data_out <= memory; // Read data from memory
    end
endmodule