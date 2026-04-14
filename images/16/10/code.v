module up_down_counter(
    input clk,
    input reset,
    input up,
    input down,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reset count to 0
        end else begin
            if (up && !down) begin
                count <= count + 1; // Count up
            end else if (down && !up) begin
                count <= count - 1; // Count down
            end
        end
    end
endmodule