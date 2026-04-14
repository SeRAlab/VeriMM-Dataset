module fifo_queue (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] fifo_memory [0:7];
    reg [2:0] write_ptr;
    reg [2:0] read_ptr;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (wr_en && !full) begin
                fifo_memory[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
                count <= count + 1;
                empty <= 0;
                if (count == 7)
                    full <= 1;
            end
            
            if (rd_en && !empty) begin
                data_out <= fifo_memory[read_ptr];
                read_ptr <= read_ptr + 1;
                count <= count - 1;
                full <= 0;
                if (count == 1)
                    empty <= 1;
            end
        end
    end
endmodule