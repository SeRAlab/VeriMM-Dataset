module up_counter
(
    input clk,
    input reset,
    input enable,
    output reg [5:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 6'b111111; // Set counter to 63
        end else if (enable) begin
            count <= count + 1; // Increment counter
        end
    end

endmodule