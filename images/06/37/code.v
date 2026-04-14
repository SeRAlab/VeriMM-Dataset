module dram_cell (
    input wire [3:0] data_in,
    input wire wr_en,
    input wire rd_en,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge wr_en) begin
        if (wr_en) begin
            storage <= data_in;
        end
    end

    always @(posedge rd_en) begin
        if (rd_en) begin
            data_out <= storage;
        end
    end

endmodule