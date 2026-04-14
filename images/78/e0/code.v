module top_module(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,  // Change output to reg type
    output empty,
    output full
);parameter BUFFER_SIZE = 16;
    reg [7:0] buffer [0:BUFFER_SIZE-1];
    reg [3:0] head = 0;
    reg [3:0] tail = 0;
    reg [3:0] count = 0;

    assign empty = (count == 0);
    assign full = (count == BUFFER_SIZE);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            data_out <= 0;  // Initialize data_out on reset
        end
        else begin
            if (wr_en && ~full) begin
                buffer[head] <= data_in;
                head <= (head == BUFFER_SIZE-1) ? 0 : head+1;
                count <= count + 1;
            end
            if (rd_en && ~empty) begin
                data_out <= buffer[tail];
                tail <= (tail == BUFFER_SIZE-1) ? 0 : tail+1;
                count <= count - 1;
            end
        end
    end

endmodule