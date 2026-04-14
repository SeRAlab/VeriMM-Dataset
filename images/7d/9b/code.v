module top_module(
    input wire [7:0] data_in,
    input wire enable_in,
    input wire clk,
    output reg [7:0] data_out,
    output reg enable_out
);parameter buffer_size = 8;
    reg [7:0] buffer [0:buffer_size-1];
    reg [2:0] head = 0;
    reg [2:0] tail = 0;
    reg [2:0] num_items = 0;

    always @(posedge clk) begin
        if (enable_in && num_items < buffer_size) begin
            buffer[head] <= data_in;
            head <= head + 1;
            num_items <= num_items + 1;
        end
        enable_out <= (num_items < buffer_size);
        data_out <= buffer[tail];
        if (num_items > 0) begin
            tail <= tail + 1;
            num_items <= num_items - 1;
        end
    end

endmodule