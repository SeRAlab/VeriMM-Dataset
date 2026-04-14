module dram_cell (
    input wire clk,
    input wire we,
    input wire re,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (we && !re) begin
            storage <= data_in; // Write data
        end
        else if (!we && re) begin
            data_out <= storage; // Read data
        end
    end
endmodule