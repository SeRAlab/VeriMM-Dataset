module fifo_queue (
    input clk,
    input rst,
    input [7:0] data_in,
    input wr_en,
    input rd_en,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    
    reg [7:0] fifo [3:0]; // FIFO storage with depth 4
    reg [1:0] head; // Points to the head of the FIFO
    reg [1:0] tail; // Points to the tail of the FIFO
    reg [2:0] count; // Number of elements in the FIFO

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (wr_en && !full) begin
                fifo[tail] <= data_in; // Write data
                tail <= tail + 1;
                count <= count + 1;
            end
            
            if (rd_en && !empty) begin
                data_out <= fifo[head]; // Read data
                head <= head + 1;
                count <= count - 1;
            end
            
            // Update full and empty flags
            full <= (count == 3'b100);
            empty <= (count == 3'b000);
        end
    end
endmodule