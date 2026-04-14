module min_heap (
    input wire [3:0] value,
    input wire [1:0] control, // 00: insert, 01: delete, 10: get
    input wire clk,
    output reg [3:0] min_value,
    output reg success
);
    reg [3:0] heap [0:15]; // Array to store heap elements
    reg [3:0] size; // Current size of the heap

    initial begin
        size = 0;
        min_value = 4'b1111; // Start with max value
        success = 0;
    end

    always @(posedge clk) begin
        case (control)
            2'b00: begin // Insert operation
                if (size < 16) begin
                    heap[size] = value;
                    size = size + 1;
                    success = 1; // Operation successful
                    // Bubble up to maintain heap property
                    // ... (Bubble up logic not shown for brevity)
                end else begin
                    success = 0; // Heap full
                end
            end
            2'b01: begin // Delete operation
                if (size > 0) begin
                    // Replace root with last element and reduce size
                    heap[0] = heap[size - 1];
                    size = size - 1;
                    // Bubble down to maintain heap property
                    // ... (Bubble down logic not shown for brevity)
                    success = 1; // Operation successful
                end else begin
                    success = 0; // Heap empty
                end
            end
            2'b10: begin // Get operation
                if (size > 0) begin
                    min_value = heap[0]; // Output the minimum value
                    success = 1; // Operation successful
                end else begin
                    min_value = 4'b1111; // Indicate no elements
                    success = 0; // Heap empty
                end
            end
        endcase
    end
endmodule