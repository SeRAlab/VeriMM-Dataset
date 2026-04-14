module up_counter
(
    input clk,
    input reset,
    input enable,
    output reg [4:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 5'b00001; // Set counter to 1
        end else if (enable) begin
            count <= count + 1; // Increment counter
        end
    end

endmodule