module top_module(
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] data_in,
    input valid_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg valid_out,
    output reg full
);parameter DATA_WIDTH = 32;
parameter BUFFER_SIZE = 16;

reg [DATA_WIDTH-1:0] buffer [BUFFER_SIZE-1:0];
reg [4:0] head, tail;
reg [4:0] count;

always @(posedge clk) begin
    if (reset) begin
        head <= 0;
        tail <= 0;
        count <= 0;
        valid_out <= 0;
        full <= 0;
    end else begin
        if (valid_in && (count < BUFFER_SIZE)) begin
            buffer[head] <= data_in;
            head <= head + 1;
            count <= count + 1;
            full <= (count == BUFFER_SIZE);
        end

        if (count > 0) begin
            data_out <= buffer[tail];
            valid_out <= 1;
            tail <= tail + 1;
            count <= count - 1;
        end

        if (count == 1) begin
            valid_out <= 0;
        end
    end
end

endmodule