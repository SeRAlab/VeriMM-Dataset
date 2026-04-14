module dram_cell (
    input wire clk,
    input wire we,
    input wire re,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] store; // 4-bit storage

    always @(posedge clk) begin
        if (we) begin
            store <= data_in; // Write data to storage
        end
        if (re) begin
            data_out <= store; // Read data from storage
        end
    end
endmodule