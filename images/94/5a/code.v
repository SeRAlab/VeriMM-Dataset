module top_module(
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    input clk,
    output reg [7:0] data_out, // Changed to reg
    output reg empty,          // Changed to reg
    output reg full            // Changed to reg
);reg [7:0] buffer [0:7];
reg [2:0] head = 0;
reg [2:0] tail = 0;
reg [2:0] count = 0;

always @(posedge clk) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        count <= 0;
        empty <= 1;
        full <= 0;
    end else begin
        if (push && !full) begin
            buffer[head] <= data_in;
            head <= (head + 1) % 8;
            count <= count + 1;
            if (count == 7) full <= 1; // Changed from 8 to 7, as count goes from 0 to 8
            empty <= 0;
        end
        if (pop && !empty) begin
            data_out <= buffer[tail];
            tail <= (tail + 1) % 8;
            count <= count - 1;
            if (count == 1) empty <= 1; // Changed from 0 to 1, as count goes from 1 to 0
            full <= 0;
        end
    end
end

endmodule