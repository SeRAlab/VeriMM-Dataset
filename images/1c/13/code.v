module dram_cell (
    input wire [3:0] data_in,
    input wire we,
    input wire re,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge we) begin
        memory <= data_in; // Write operation
    end

    always @(posedge re) begin
        data_out <= memory; // Read operation
    end
endmodule