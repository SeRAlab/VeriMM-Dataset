module dram_cell(
    input clk,
    input [15:0] data_in,
    input write_enable,
    input read_enable,
    output reg [15:0] data_out
);
    reg [15:0] storage;

    always @(posedge clk) begin
        if (write_enable) begin
            storage <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= storage;
        end
    end
endmodule