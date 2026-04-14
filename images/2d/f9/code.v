module dram_cell (
    input wire [15:0] data_in,
    input wire we,
    input wire re,
    input wire clk,
    output reg [15:0] data_out
);

    reg [15:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write data into the storage
        end
        if (re) begin
            data_out <= storage; // Read data from the storage
        end
    end
endmodule