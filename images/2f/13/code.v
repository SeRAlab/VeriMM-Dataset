module SRAM_4bit (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    input wire WE,
    input wire CE,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 4'b0000;
            data_out <= 4'b0000;
        end else if (!CE) begin
            if (!WE) begin
                memory <= data_in;  // Write operation
            end else begin
                data_out <= memory;  // Read operation
            end
        end
    end
endmodule