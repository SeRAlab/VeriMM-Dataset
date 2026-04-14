module SRAM (
    input clk,
    input we,
    input [3:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [15:0];

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in;  // Write operation
        end else begin
            data_out <= memory[addr];  // Read operation
        end
    end
endmodule