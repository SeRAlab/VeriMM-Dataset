module dram_cell (
    input wire clk,
    input wire we,
    input wire re,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write operation
        end
        if (re) begin
            data_out <= storage; // Read operation
        end
    end
endmodule