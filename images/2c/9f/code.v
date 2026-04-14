module dram_cell (
    input wire [7:0] data_in,
    input wire we,
    input wire re,
    output reg [7:0] data_out
);
    reg [7:0] storage;

    always @(*) begin
        if (we) begin
            storage <= data_in; // Write data
        end
        if (re) begin
            data_out <= storage; // Read data
        end
    end
endmodule