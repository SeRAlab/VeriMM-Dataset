module dram_cell (
    input wire [15:0] data_in,
    input wire control,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(negedge control) begin
        memory <= data_in; // Write operation
    end

    always @(posedge control) begin
        data_out <= memory; // Read operation
    end
endmodule