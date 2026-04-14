module dram_cell (
    input clk,
    input we,            // Write enable
    input [15:0] data_in, // 16-bit Data input
    output reg [15:0] data_out // 16-bit Data output
);

    // 16-bit Register for storing data
    reg [15:0] storage;

    always @(posedge clk) begin
        if (we) begin
            // Write data into storage
            storage <= data_in;
        end
        // Always output the stored data
        data_out <= storage;
    end
endmodule