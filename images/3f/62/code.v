module SRAM_Cell (
    input wire [3:0] data_in,
    input wire write_enable,
    input wire clk,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in;  // Write operation
        end
    end

    always @(*) begin
        data_out = memory;  // Read operation
    end
endmodule