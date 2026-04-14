module down_counter
(
    input clk,
    input reset,
    input enable,
    output reg [6:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 7'b1111111; // Set counter to 127
        end else if (enable) begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule