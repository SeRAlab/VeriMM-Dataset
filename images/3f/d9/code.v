module DRAM_Cell (
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire load,
    input wire clk
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (load) begin
            memory <= data_in; // Store data on load signal
        end
    end

    always @(negedge load) begin
        data_out <= memory; // Output data when load is low
    end
endmodule