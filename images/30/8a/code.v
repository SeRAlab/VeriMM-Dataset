module dram_cell (
    input wire [3:0] data_in,
    input wire RE,
    input wire WE,
    input wire CLK,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge CLK) begin
        if (WE) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge CLK) begin
        if (RE) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule