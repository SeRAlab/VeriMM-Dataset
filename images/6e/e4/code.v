module binary_counter
(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count
);
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b1111; // Set counter to 15
        end else if (enable) begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule