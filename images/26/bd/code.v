module timer_8bit (
    input clk,
    input reset,
    input start,
    output reg [7:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b00000000; // Reset count to 0
        end else if (start) begin
            if (count < 8'b11111111) begin
                count <= count + 1; // Increment count
            end else begin
                count <= 8'b00000000; // Wrap around to 0
            end
        end
    end
endmodule