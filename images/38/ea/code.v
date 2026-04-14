module SRAM (
    input wire clk,
    input wire en,
    input wire we,
    input wire [3:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

    reg [15:0] memory [0:15];

    always @(posedge clk) begin
        if (en) begin
            if (we) begin
                memory[addr] <= data_in; // Write operation
            end else begin
                data_out <= memory[addr]; // Read operation
            end
        end
    end
endmodule