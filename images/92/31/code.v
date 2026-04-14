module top_module(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out
);reg [7:0] buffer [0:15];
    reg [3:0] head = 0;
    reg [3:0] tail = 0;
    reg empty = 1;
    reg full = 0;

    always @(posedge clk) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (wr_en && !full) begin
                buffer[head] <= data_in;
                head <= head + 1;
                if (head == 16) begin
                    head <= 0;
                end
                empty <= 0;
                if (head == tail) begin
                    full <= 1;
                end
            end
            if (rd_en && !empty) begin
                data_out <= buffer[tail];
                tail <= tail + 1;
                if (tail == 16) begin
                    tail <= 0;
                end
                full <= 0;
                if (tail == head) begin
                    empty <= 1;
                end
            end
        end
    end

endmodule