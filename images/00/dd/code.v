module UpDownCounter (
    input clk,
    input reset,
    input enable,
    input up_down, // 1 for up, 0 for down
    output reg [3:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reset the counter to 0
        end else if (enable) begin
            if (up_down) begin
                count <= count + 1; // Count up
            end else begin
                count <= count - 1; // Count down
            end
        end
    end
endmodule