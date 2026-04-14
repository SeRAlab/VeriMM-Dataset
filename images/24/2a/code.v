module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] stored_data;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_data <= data_in;
        end
    end

    always @(*) begin
        if (!write_enable) begin
            data_out = stored_data;
        end
    end
endmodule