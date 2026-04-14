module dram_cell (
    input wire we,       // Write enable
    input wire re,       // Read enable
    input wire [3:0] data_in,  // 4-bit data input
    output reg [3:0] data_out  // 4-bit data output
);
    reg [3:0] storage; // Internal storage of the DRAM cell

    always @(posedge we) begin
        storage <= data_in; // Write data to storage on write enable
    end

    always @(posedge re) begin
        data_out <= storage; // Read data from storage on read enable
    end
endmodule