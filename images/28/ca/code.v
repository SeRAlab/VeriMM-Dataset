module dram_cell (
    input wire [15:0] data_in,
    input wire we,
    input wire re,
    output reg [15:0] data_out
);
    reg [15:0] storage;

    always @(posedge we) begin
        storage <= data_in;
    end

    always @(posedge re) begin
        data_out <= storage;
    end
endmodule