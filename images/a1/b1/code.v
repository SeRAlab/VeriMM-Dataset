module top_module(
    input clock,
    input [35:0] data,
    input rdreq,
    input wrreq,
    output empty,
    output full,
    output reg [35:0] q, // Changed from wire to reg
    output [7:0] usedw
);// Internal FIFO memory
    reg [35:0] mem [0:255];
    // Read and write pointers
    reg [7:0] rptr = 0;
    reg [7:0] wptr = 0;
    // Number of words in the FIFO
    reg [7:0] count = 0;

    // Full and empty signals
    assign empty = (count == 0);
    assign full = (count == 256);

    // Read logic
    always @(posedge clock) begin
        if (rdreq && !empty) begin
            q <= mem[rptr];  // This is now a valid assignment
            rptr <= rptr + 1;
            count <= count - 1;
        end
    end

    // Write logic
    always @(posedge clock) begin
        if (wrreq && !full) begin
            mem[wptr] <= data;
            wptr <= wptr + 1;
            count <= count + 1;
        end
    end

    // Output the number of words used in the FIFO
    assign usedw = count;

endmodule