module binary_counter
(
    input clk,
    input reset,
    output reg [1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00; // Reset counter to 00
        end else begin
            count <= count + 1; // Increment counter
        end
    end

endmodule