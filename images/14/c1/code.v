module dram_cell (
    input [15:0] data_in,
    input we,
    input clk,
    output reg [15:0] data_out
);
    reg [15:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in;  // Write data to storage
        end
    end

    always @(negedge clk) begin
        data_out <= storage;  // Output data from storage
    end
endmodule