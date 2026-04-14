module top_module(
    input CLK,
    input [1:0] DIA,
    input [1:0] DIB,
    input [1:0] DIC,
    output reg [5:0] Q,  // Change to reg type
    output out
);reg [5:0] fifo [0:31];
reg full;
reg empty;
reg [4:0] head;
reg [4:0] tail;

always @(posedge CLK) begin
    // Write data to FIFO
    if (!full) begin
        fifo[head] <= {DIA, DIB, DIC};  // Use non-blocking assignment
        head <= head + 1;               // Use non-blocking assignment
        if (head == 32) begin
            head <= 0;                   // Use non-blocking assignment
        end
        if (head == tail) begin
            full <= 1;                   // Use non-blocking assignment
        end
    end

    // Read data from FIFO
    if (!empty) begin
        Q <= fifo[tail];                 // Use non-blocking assignment
        tail <= tail + 1;                // Use non-blocking assignment
        if (tail == 32) begin
            tail <= 0;                    // Use non-blocking assignment
        end
        if (tail == head) begin
            empty <= 1;                   // Use non-blocking assignment
        end
    end
end

assign out = full;

endmodule