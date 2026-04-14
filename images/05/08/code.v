module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire reset,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

    reg [15:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 16'b0; // Reset memory
            data_out <= 16'b0; // Reset output
        end else begin
            if (write_enable) begin
                memory <= data_in; // Write input data to memory
            end
            if (read_enable) begin
                data_out <= memory; // Read memory to output
            end
        end
    end

endmodule