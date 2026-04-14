module SRAM_8bit (
    input wire [7:0] data_in,
    input wire we,
    input wire read,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge we or posedge read) begin
        if (we) begin
            memory <= data_in; // Write operation
        end
    end

    always @(posedge read) begin
        data_out <= memory; // Read operation
    end
endmodule