module slam_system(
    input clk,
    input reset,
    input [3:0] distance,
    input control,
    output reg [3:0] position
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 4'b0000; // Initialize position to 0
        end else if (control) begin
            position <= position + distance; // Update position
        end
    end
endmodule