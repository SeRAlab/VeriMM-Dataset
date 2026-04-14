module sram_cell (
    input wire clk,
    input wire we,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

reg [15:0] storage;

always @(posedge clk) begin
    if (we) begin
        storage <= data_in; // Write data to SRAM
    end
    data_out <= storage; // Always output the stored data
end

endmodule