module sram_16bit (
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire [3:0] address,
    input wire we,
    input wire clk
);
    reg [15:0] memory [15:0]; // 16 words of 16 bits each

    always @(posedge clk) begin
        if (we) begin
            memory[address] <= data_in; // Write operation
        end else begin
            data_out <= memory[address]; // Read operation
        end
    end
endmodule