module top_module(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [31:0] data_in,
    output reg [31:0] data_out  // Changed wire to reg
);parameter DEPTH = 16;

reg [31:0] buffer [0:DEPTH-1];
reg [5:0] head = 0;
reg [5:0] tail = 0;
reg [5:0] count = 0;

always @(posedge clk) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        count <= 0;
        data_out <= 32'b0;  // Initialize data_out on reset
    end else begin
        if (wr_en && !rd_en && count < DEPTH) begin
            buffer[head] <= data_in;
            head <= head + 1;
            count <= count + 1;
        end
        if (!wr_en && rd_en && count > 0) begin
            data_out <= buffer[tail];
            tail <= tail + 1;
            count <= count - 1;
        end
    end
end

endmodule