module down_counter (
    input clk,
    input reset,
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b1111; // Resetting to 15
    end else if (count > 0) begin
        count <= count - 1; // Decrementing the counter
    end
end

endmodule