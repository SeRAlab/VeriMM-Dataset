module SRAM_4bit (
    input wire [3:0] data_in,
    input wire we,
    input wire re,
    output reg [3:0] data_out
);
    reg [3:0] memory; // Internal memory for the SRAM cell

    always @(*) begin
        if (we)
            memory <= data_in; // Write operation
        if (re)
            data_out <= memory; // Read operation
    end
endmodule