module fifo_queue (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] fifo [0:3]; // FIFO storage
    reg [1:0] wr_ptr, rd_ptr; // write and read pointers
    reg [2:0] count; // number of elements in FIFO

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 2'b00;
            rd_ptr <= 2'b00;
            count <= 3'b000;
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            // Write operation
            if (wr_en && !full) begin
                fifo[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            
            // Read operation
            if (rd_en && !empty) begin
                data_out <= fifo[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end

            // Update empty and full flags
            empty <= (count == 0);
            full <= (count == 4);
        end
    end
endmodule