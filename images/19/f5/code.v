module dram_cell (
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    input wire write_enable,
    input wire read_enable,
    input wire clk
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Store input data when write_enable is high
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= memory; // Output stored data when read_enable is high
        end
    end
endmodule