module fifo_queue (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    
    reg [7:0] memory [0:7];
    reg [2:0] head, tail, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 3'b000;
            tail <= 3'b000;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            // Write Operation
            if (wr_en && !full) begin
                memory[head] <= data_in;
                head <= head + 1'b1;
                count <= count + 1'b1;
                empty <= 1'b0;
            end
            
            // Read Operation
            if (rd_en && !empty) begin
                data_out <= memory[tail];
                tail <= tail + 1'b1;
                count <= count - 1'b1;
                full <= 1'b0;
            end
            
            // Update full and empty flags
            if (count == 3'b111) full <= 1'b1;
            if (count == 3'b000) empty <= 1'b1;
        end
    end
endmodule