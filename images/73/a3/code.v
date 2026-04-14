module fifo_8bit_16word (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);

reg [7:0] mem [0:15];
reg [3:0] rd_ptr, wr_ptr;
reg [4:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rd_ptr <= 4'b0;
        wr_ptr <= 4'b0;
        count <= 5'b0;
        full <= 1'b0;
        empty <= 1'b1;
    end
    else begin
        if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end
        if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end
        full <= (count == 16);
        empty <= (count == 0);
    end
end

endmodule