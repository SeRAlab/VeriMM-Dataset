module fifo_queue (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] fifo_mem [3:0]; // FIFO memory array of depth 4
    reg [1:0] wr_ptr;         // Write pointer
    reg [1:0] rd_ptr;         // Read pointer
    reg [2:0] count;          // Number of elements in FIFO

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 2'b00;
            rd_ptr <= 2'b00;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
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
            
            full <= (count == 3'b100);  // Count is 4
            empty <= (count == 3'b000); // Count is 0
        end
    end
endmodule