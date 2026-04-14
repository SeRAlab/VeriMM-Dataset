module top_module(
    input clk,
    input reset,
    input [7:0] data_in,
    input write_en,
    input read_en,
    output reg [7:0] data_out, // Change wire to reg for data_out
    output full,
    output empty,
    output reg [3:0] count
);reg [7:0] fifo [15:0];
    reg [3:0] head = 0;
    reg [3:0] tail = 0;
    wire [3:0] next_head = head + 1;
    wire [3:0] next_tail = tail + 1;
    
    always @(posedge clk) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            data_out <= 8'b0; // Ensure data_out is reset
        end else begin
            if (write_en && !full) begin
                fifo[head] <= data_in;
                head <= next_head;
                count <= count + 1;
            end
            if (read_en && !empty) begin
                data_out <= fifo[tail];
                tail <= next_tail;
                count <= count - 1;
            end
        end
    end
    
    assign full = (count == 16);
    assign empty = (count == 0);

endmodule