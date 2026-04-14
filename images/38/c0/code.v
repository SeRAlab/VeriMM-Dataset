module fifo_queue (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    input wire wr_en,
    input wire rd_en,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] queue [3:0]; // 4-depth FIFO queue
    reg [1:0] write_ptr;
    reg [1:0] read_ptr;
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 2'b00;
            read_ptr <= 2'b00;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (wr_en && ~full) begin
                queue[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1'b1;
                count <= count + 1'b1;
            end
            if (rd_en && ~empty) begin
                data_out <= queue[read_ptr];
                read_ptr <= read_ptr + 1'b1;
                count <= count - 1'b1;
            end

            full <= (count == 3'b100);
            empty <= (count == 3'b000);
        end
    end
endmodule