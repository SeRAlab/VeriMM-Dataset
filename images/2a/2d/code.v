module SRAM_Cell (
    input [7:0] data_in,
    output reg [7:0] data_out,
    input we,
    input re,
    input clk
);
    reg [7:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write data to storage
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= storage; // Read data from storage
        end
    end
endmodule