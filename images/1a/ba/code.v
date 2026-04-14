module SRAM_4bit (
    input [3:0] data_in,
    input write_enable,
    input clk,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (write_enable) begin
            storage <= data_in;
        end
    end

    always @(posedge clk) begin
        data_out <= storage;
    end
endmodule