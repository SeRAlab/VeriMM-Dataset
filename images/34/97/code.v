module sliding_window_fifo (
    input clk,
    input reset,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    parameter SIZE = 4;
    reg [7:0] fifo [0:SIZE-1];
    reg [1:0] wr_ptr, rd_ptr, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (wr_en && !full) begin
                fifo[wr_ptr] <= data_in;
                wr_ptr <= (wr_ptr + 1) % SIZE;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                data_out <= fifo[rd_ptr];
                rd_ptr <= (rd_ptr + 1) % SIZE;
                count <= count - 1;
            end

            full <= (count == SIZE);
            empty <= (count == 0);
        end
    end
endmodule