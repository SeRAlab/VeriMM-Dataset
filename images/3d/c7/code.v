module sram_cell (
    input wire [7:0] data_in,
    input wire we,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(*) begin
        if (we) begin
            memory <= data_in; // Write operation
        end else begin
            data_out <= memory; // Read operation
        end
    end
endmodule