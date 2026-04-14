module top_module(
    input clk,
    input reset,
    input [7:0] data_in,
    input write,
    output reg [7:0] data_out,  // Changed from wire to reg
    input read,
    output empty,
    output full
);reg [7:0] buffer [0:15];
    reg [3:0] head = 0;
    reg [3:0] tail = 0;
    reg [3:0] count = 0;
    
    always @(posedge clk) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            count <= 0;
        end else begin
            if (write && !full) begin
                buffer[head] <= data_in;
                head <= (head == 15) ? 0 : head + 1;
                count <= count + 1;
            end
            if (read && !empty) begin
                data_out <= buffer[tail];
                tail <= (tail == 15) ? 0 : tail + 1;
                count <= count - 1;
            end
        end
    end
    
    assign empty = (count == 0);
    assign full = (count == 16);
    
endmodule