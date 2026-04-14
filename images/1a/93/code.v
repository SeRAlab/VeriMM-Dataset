module sram_8bit (
    input wire clk,
    input wire we,
    input wire [2:0] addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8 locations of 8 bits each

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end else begin
            data_out <= memory[addr]; // Read operation
        end
    end
endmodule