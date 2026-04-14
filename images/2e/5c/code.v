module sram_cell (
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire we,
    input wire cs,
    input wire clk
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (!cs) begin
            if (we) begin
                memory <= data_in; // Write data
            end else begin
                data_out <= memory; // Read data
            end
        end
    end
endmodule