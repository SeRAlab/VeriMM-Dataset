module SRAM_4bit (
    input wire [3:0] data_in,
    input wire we,
    input wire re,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge we or posedge re) begin
        if (we) begin
            memory <= data_in;  // Write data when write enable is high
        end
    end

    always @(posedge re) begin
        if (re) begin
            data_out <= memory;  // Read data when read enable is high
        end
    end
endmodule