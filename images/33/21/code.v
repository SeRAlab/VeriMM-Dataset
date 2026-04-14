module SRAM_4bit (
    input wire we,
    input wire [1:0] addr,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3];

    always @(posedge we) begin
        if (we) begin
            memory[addr] <= data_in; // write data to the selected address
        end
    end

    always @(*) begin
        if (!we) begin
            data_out = memory[addr]; // read data from the selected address
        end
    end
endmodule