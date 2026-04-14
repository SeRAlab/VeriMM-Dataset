module SRAM16 (
    input wire [15:0] data_in,
    input wire write_enable,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory <= data_in;
        end
    end

    always @(*) begin
        data_out = memory;
    end
endmodule