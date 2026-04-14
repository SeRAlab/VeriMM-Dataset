module fifo_queue (
    input clk,
    input reset,
    input [7:0] data_in,
    input write_enable,
    input read_enable,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);

    reg [7:0] fifo [3:0]; // FIFO storage
    reg [1:0] head, tail; // Head and tail pointers
    reg [2:0] count; // Number of elements in FIFO

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 8'b00000000;
        end else begin
            if (write_enable && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            
            if (read_enable && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
            
            full <= (count == 3'b100);
            empty <= (count == 3'b000);
        end
    end
endmodule