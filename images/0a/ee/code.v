module fifo (
    input clk,
    input reset,
    input wr_en,
    input rd_en,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] fifo_mem [3:0];
    reg [1:0] wr_ptr;
    reg [1:0] rd_ptr;
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 2'b00;
            rd_ptr <= 2'b00;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
            full <= (count == 4);
            empty <= (count == 0);
        end
    end
endmodule