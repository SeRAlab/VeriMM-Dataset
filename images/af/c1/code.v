module binary_counter
(
    input clk,
    input reset,
    input enable,
    output reg [9:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 10'b1010101010; // Set counter to 682
        end else if (enable) begin
            count <= count + 1; // Increment counter
        end
    end

endmodule