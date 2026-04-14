module dram_cell (
    input clk,
    input we,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write data to storage
        end
        else begin
            data_out <= storage; // Read data from storage
        end
    end
endmodule