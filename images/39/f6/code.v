module dram_cell (
    input wire clk,
    input wire we, // write enable
    input wire re, // read enable
    input wire [15:0] data_in, // data input
    output reg [15:0] data_out // data output
);
    reg [15:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write data to storage
        end
        if (re) begin
            data_out <= storage; // Read data from storage
        end
    end
endmodule