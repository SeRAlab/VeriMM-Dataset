module fifo_queue (
    input clk,
    input rst,
    input [3:0] data_in,
    input wr_en,
    input rd_en,
    output reg [3:0] data_out,
    output reg empty
);
    reg [3:0] fifo_mem [3:0]; // FIFO memory
    reg [1:0] wr_ptr; // Write pointer
    reg [1:0] rd_ptr; // Read pointer
    reg [2:0] count; // Number of items in the FIFO

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 2'b00;
            rd_ptr <= 2'b00;
            count <= 3'b000;
            empty <= 1'b1;
        end else begin
            if (wr_en && count < 4) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
                empty <= 1'b0;
            end
            if (rd_en && count > 0) begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
                if (count == 1) empty <= 1'b1;
            end
        end
    end
endmodule