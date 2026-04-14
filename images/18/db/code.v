module sram_4bit (
    input wire [3:0] data_in,
    input wire [1:0] addr,
    input wire we,
    input wire clk,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4 x 4-bit SRAM cells

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end else begin
            data_out <= memory[addr]; // Read operation
        end
    end
endmodule