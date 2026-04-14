module binary_counter
(
    input clk,
    input reset,
    input enable,
    output reg [4:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b11111; // Set counter to 31
        end else if (enable) begin
            count <= count - 2; // Decrement counter by 2
        end
    end

endmodule