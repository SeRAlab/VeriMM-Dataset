module DRAM_Cell (
    input wire clk,
    input wire we,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write operation
        end
    end

    always @(negedge clk) begin
        if (!we) begin
            data_out <= memory; // Read operation
        end
    end
endmodule