module top_module(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [31:0] din,
    output reg [31:0] dout, // Change to reg since we are assigning it in an always block
    output empty,
    output full
);parameter DEPTH = 256; // FIFO depth
    parameter WIDTH = 32; // Data width

    reg [WIDTH-1:0] fifo[DEPTH-1:0]; // FIFO memory
    // reg [WIDTH-1:0] dout; // Removed this line since dout is declared as an output
    // wire empty; // Removed this line since empty is declared as an output
    // wire full; // Removed this line since full is declared as an output
    reg [7:0] head = 0; // Head pointer
    reg [7:0] tail = 0; // Tail pointer
    reg [7:0] count = 0; // Number of elements in the FIFO

    always @(posedge clk) begin
        if (rst) begin // Reset the FIFO
            head <= 0;
            tail <= 0;
            count <= 0;
            dout <= 0; // Reset dout on reset
        end else begin
            if (wr_en && !full) begin // Write data to the FIFO
                fifo[head] <= din;
                head <= head + 1;
                count <= count + 1;
                if (head == DEPTH) head <= 0; // Wrap around
            end
            if (rd_en && !empty) begin // Read data from the FIFO
                dout <= fifo[tail];
                tail <= tail + 1;
                count <= count - 1;
                if (tail == DEPTH) tail <= 0; // Wrap around
            end
        end
    end

    assign empty = (count == 0);
    assign full = (count == DEPTH);

endmodule