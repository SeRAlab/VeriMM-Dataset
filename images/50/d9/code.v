module top_module(
    input clk, rst, dataReady,
    input [7:0] data,
    output reg txStart,
    output reg [7:0] txData,
    output reg empty,
    output reg full,
    output reg txBusy
);reg [7:0] buffer [0:7];
    reg [2:0] head, tail;
    reg [2:0] count;
    reg [7:0] currentByte;
    
    always @(posedge clk) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
            txBusy <= 0;
            txStart <= 0;
            txData <= 0;
        end
        else begin
            if (dataReady && !full) begin
                buffer[head] <= data;
                head <= (head == 7) ? 0 : head + 1;
                count <= count + 1;
                empty <= 0;
                if (count == 8) full <= 1;
            end
            
            if (!txBusy && !empty) begin
                currentByte <= buffer[tail];
                tail <= (tail == 7) ? 0 : tail + 1;
                count <= count - 1;
                full <= 0;
                if (count == 0) empty <= 1;
                txBusy <= 1;
                txStart <= 1;
                txData <= currentByte;
            end
            else if (txBusy) begin
                txStart <= 0;
                txData <= 0;
                txBusy <= 0;
            end
        end
    end

endmodule