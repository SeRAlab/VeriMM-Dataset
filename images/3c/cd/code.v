module fifo_queue (
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] fifo_mem [0:7]; // 8 entries of 4 bits each
    reg [2:0] read_ptr;
    reg [2:0] write_ptr;
    reg [3:0] count; // to track the number of elements in the FIFO

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_ptr <= 3'b000;
            write_ptr <= 3'b000;
            count <= 4'b0000;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1'b1;
                count <= count + 1'b1;
            end

            if (rd_en && !empty) begin
                data_out <= fifo_mem[read_ptr];
                read_ptr <= read_ptr + 1'b1;
                count <= count - 1'b1;
            end

            // Update full and empty flags
            full <= (count == 4'b1000);
            empty <= (count == 4'b0000);
        end
    end
endmodule