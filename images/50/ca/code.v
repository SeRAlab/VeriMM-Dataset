module down_counter
(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0111; // Set counter to 7
        end else if (enable) begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule