module top_module(
    input clk,
    input reset,
    input write,
    input read,
    input clear,
    input [31:0] data_in,
    output reg [31:0] data_out, // Changed from wire to reg
    output almost_full,
    output full,
    output almost_empty,
    output empty
);parameter DEPTH = 8;

reg [31:0] buffer [0:DEPTH-1];
reg [2:0] count;
reg [2:0] read_pointer;
reg [2:0] write_pointer;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
        read_pointer <= 0;
        write_pointer <= 0;
    end else if (clear) begin
        count <= (read != write) ? count : 0;
        read_pointer <= (read) ? 1'b1 : read_pointer;  // This needs more logic to handle resets
        write_pointer <= (write) ? 1'b1 : write_pointer; // This needs more logic to handle resets
    end else if (read != write) begin
        count <= (read > write) ? (DEPTH - read + write) : (write - read);
        read_pointer <= (read_pointer == DEPTH-1) ? 0 : read_pointer + 1'b1;
        write_pointer <= (write_pointer == DEPTH-1) ? 0 : write_pointer + 1'b1;
    end
end

assign empty = (count == 0);
assign full = (count == DEPTH);
assign almost_empty = (count <= 1);
assign almost_full = (count >= DEPTH-1);

always @(posedge clk) begin
    if (clear) begin
        data_out <= 0; // Reset data_out to 0 or could hold a similar placeholder
    end else if (read != write) begin
        data_out <= buffer[read_pointer];
    end
end

always @(posedge clk) begin
    if (write && !full) begin
        buffer[write_pointer] <= data_in;
    end
end

endmodule