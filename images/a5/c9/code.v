module top_module(
    input clk,
    input reset,
    input direction,
    output reg [15:0] count,
    output [3:0] overflows
);reg [15:0] max_val = 16'd9999; // Maximum value of the counter
    reg [15:0] min_val = 16'd0000; // Minimum value of the counter
    reg [3:0] overflow_count = 4'b0000; // Counter for number of overflows

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0000;
            overflow_count <= 4'b0000;
        end else begin
            if (direction) begin
                if (count == max_val) begin
                    count <= min_val;
                    overflow_count <= overflow_count + 1;
                end else begin
                    count <= count + 1;
                end
            end else begin
                if (count == min_val) begin
                    count <= max_val;
                    overflow_count <= overflow_count + 1;
                end else begin
                    count <= count - 1;
                end
            end
        end
    end

    assign overflows = overflow_count;

endmodule