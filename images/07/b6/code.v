module dram_cell (
    input wire clk,
    input wire wr_en,
    input wire rd_en,
    input wire data_in,
    output reg data_out
);
    reg stored_data;

    always @(posedge clk) begin
        if (wr_en) begin
            stored_data <= data_in;
        end
    end

    always @(posedge clk) begin
        if (rd_en) begin
            data_out <= stored_data;
        end
    end
endmodule