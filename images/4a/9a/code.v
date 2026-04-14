module top_module(
    input clk,
    input rst_n,
    input ce,
    input ctrl,
    output reg [3:0] count,
    output reg tc,        // Changed from wire to reg
    output reg borrow     // Changed from wire to reg
);// Internal signals
    reg [3:0] next_count;

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000;
            next_count <= 4'b0000; // Initialize next_count on reset
        end else if (ce) begin
            if (ctrl) begin
                next_count <= count - 1;
            end else begin
                next_count <= count + 1;
            end
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tc <= 1'b0;
            borrow <= 1'b0;
        end else begin
            count <= next_count;
            if (ctrl) begin
                tc <= (next_count == 4'b0000); // Use next_count for comparison
                borrow <= (count == 4'b0000);   // Borrow occurs when count becomes zero
            end else begin
                tc <= (next_count == 4'b1111); // Use next_count for comparison
                borrow <= 1'b0;
            end
        end
    end

endmodule