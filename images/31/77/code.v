module SRAM (
    input wire [2:0] addr,
    input wire [7:0] data_in,
    input wire we,
    input wire clk,
    input wire reset,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8 locations of 8 bits each

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1) begin
                memory[i] <= 8'b0; // Initialize memory to 0
            end
            data_out <= 8'b0; // Reset output
        end else begin
            if (we) begin
                memory[addr] <= data_in; // Write data
            end else begin
                data_out <= memory[addr]; // Read data
            end
        end
    end
endmodule