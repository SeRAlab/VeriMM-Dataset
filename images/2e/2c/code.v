module sram_4bit (
    input wire clk,
    input wire enable,
    input wire write,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (enable) begin
            if (write) begin
                memory <= data_in; // Write operation
            end
            data_out <= memory; // Read operation
        end
    end
endmodule