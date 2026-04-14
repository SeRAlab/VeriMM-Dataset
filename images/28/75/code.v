module fifo_queue (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire write_en,
    input wire read_en,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] fifo [0:3];  // FIFO depth of 4
    reg [1:0] head, tail, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (write_en && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (read_en && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end

            // Update full and empty flags
            full <= (count == 4);
            empty <= (count == 0);
        end
    end
endmodule