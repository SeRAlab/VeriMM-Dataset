module slam_position_estimator (
    input wire clk,
    input wire reset,
    input wire [7:0] distance,
    output reg [7:0] position
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        position <= 8'b0;
    end else begin
        position <= position + distance; // Simple position update
    end
end

endmodule