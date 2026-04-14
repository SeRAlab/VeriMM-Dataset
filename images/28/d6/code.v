module UpDownCounter (
    input clk,
    input reset,
    input up,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reset the counter to 0
        end else if (up) begin
            count <= (count == 4'b1111) ? 4'b0000 : count + 1; // Count up with wrap-around
        end else begin
            count <= (count == 4'b0000) ? 4'b1111 : count - 1; // Count down with wrap-around
        end
    end
endmodule