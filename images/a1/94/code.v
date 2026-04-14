module top_module(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);reg [7:0] buffer [0:7];
reg [2:0] head;
reg [2:0] tail;

always @(posedge clk) begin
    if (rst) begin
        head <= 3'b0;
        tail <= 3'b0;
        empty <= 1'b1;
        full <= 1'b0;
    end else begin
        if (wr_en && !full) begin
            buffer[head] <= data_in;
            head <= head + 1;
            if (head == 3'b100) begin
                head <= 3'b0;
            end
            empty <= 1'b0;
            if (head == tail) begin
                full <= 1'b1;
            end
        end
        if (rd_en && !empty) begin
            data_out <= buffer[tail];
            tail <= tail + 1;
            if (tail == 3'b100) begin
                tail <= 3'b0;
            end
            full <= 1'b0;
            if (head == tail) begin
                empty <= 1'b1;
            end
        end
    end
end

endmodule