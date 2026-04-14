module MinHeap (
    input wire clk,
    input wire reset,
    input wire insert,
    input wire [31:0] data_in,
    input wire remove_min,
    output reg [31:0] min_out,
    output reg valid_out
);

    reg [31:0] heap [0:15];
    reg [3:0] size;

    initial begin
        size = 0;
        valid_out = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            size <= 0;
            valid_out <= 0;
        end else begin
            if (insert) begin
                if (size < 16) begin
                    heap[size] = data_in;
                    size = size + 1;
                    // Reheapify after insertion
                end
            end
            if (remove_min) begin
                if (size > 0) begin
                    min_out = heap[0];
                    valid_out = 1;
                    // Remove the min and reheapify
                    heap[0] = heap[size - 1];
                    size = size - 1;
                end else begin
                    valid_out = 0;
                end
            end
            if (size > 0) begin
                min_out = heap[0];
                valid_out = 1;
            end else begin
                valid_out = 0;
            end
        end
    end
endmodule