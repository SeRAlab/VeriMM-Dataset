module down_counter
(
    input clk,
    input reset,
    input enable,
    output reg [4:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b10010; // Set counter to 18
        end else if (enable) begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule