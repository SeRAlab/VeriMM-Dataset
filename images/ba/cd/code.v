module top_module(
    input clk,
    input rst,
    input rx,
    input rx_valid,
    output reg rx_ready,
    output reg rx_ack,
    output reg tx,
    output reg tx_valid,
    input tx_ready,
    input tx_ack
);parameter BUFFER_SIZE = 16; // Set the size of the FIFO buffer

reg [7:0] buffer[BUFFER_SIZE-1:0]; // Create a FIFO buffer to store the received data
reg [3:0] head = 0; // Track the head of the buffer
reg [3:0] tail = 0; // Track the tail of the buffer
reg [3:0] count = 0; // Track the number of elements in the buffer

always @(posedge clk) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        count <= 0;
        rx_ack <= 0;
        tx_valid <= 0;
    end else begin
        // Update rx_ready
        rx_ready <= (count < BUFFER_SIZE); // Set rx_ready to indicate whether there is space in the buffer

        if (rx_valid && rx_ready) begin
            buffer[head] <= rx;
            head <= (head == BUFFER_SIZE-1) ? 0 : head + 1;
            count <= count + 1;
            rx_ack <= 1;
        end else begin
            rx_ack <= 0;
        end

        if (tx_ready && count > 0) begin
            tx <= buffer[tail];
            tail <= (tail == BUFFER_SIZE-1) ? 0 : tail + 1;
            count <= count - 1;
            tx_valid <= 1;
        end else begin
            tx_valid <= 0;
        end
    end
end

endmodule