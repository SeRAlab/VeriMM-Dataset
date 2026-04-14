module flash_memory_cell (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory <= 8'b0;
            data_out <= 8'b0;
        end
        else if (wr_en) begin
            memory <= data_in;
        end
        else if (rd_en) begin
            data_out <= memory;
        end
    end
endmodule