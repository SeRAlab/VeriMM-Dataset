module dram_cell (
    input clk,
    input enable,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (enable) begin
            storage <= data_in; // Write Operation
        end
        data_out <= storage; // Read Operation
    end
endmodule