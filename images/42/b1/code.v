module fifo_buffer(
   input                clk,
   input                rst,
   input                wr_en,
   input                rd_en,
   input [7:0]          wr_data,

   output reg [7:0]     rd_data,
   output reg           full,
   output reg           empty
);
    reg [7:0] memory [15:0];
    reg [3:0] rd_ptr, wr_ptr;
    reg [4:0] fifo_count;

    always@(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 4'd0;
            wr_ptr <= 4'd0;
            fifo_count <= 5'd0;
            full <= 1'b0;
            empty <= 1'b1;
        end
        else begin
            if (wr_en && !full) begin
                memory[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1;
                fifo_count <= fifo_count + 1;
            end
            if (rd_en && !empty) begin
                rd_data <= memory[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                fifo_count <= fifo_count - 1;
            end
            full <= (fifo_count == 16);
            empty <= (fifo_count == 0);
        end
    end
endmodule