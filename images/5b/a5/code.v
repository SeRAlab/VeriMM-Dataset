module up_down_counter(
    input clk,
    input reset,
    input enable,
    input up_down,
    output reg [3:0] count
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000;  // Synchronous reset to zero
        end else if (enable) begin
            if (up_down) begin
                count <= count + 1;  // Count up when up_down is high
            end else begin
                count <= count - 1;  // Count down when up_down is low
            end
        end
    end

endmodule