module rrt_path_finder (
    input wire clk,
    input wire reset,
    input wire [7:0] random_x,
    input wire [7:0] random_y,
    input wire [7:0] target_x,
    input wire [7:0] target_y,
    output reg valid_path
);
    parameter THRESHOLD = 10; // distance threshold for valid path
    reg [15:0] distance;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_path <= 0;
        end else begin
            distance <= (random_x - target_x)**2 + (random_y - target_y)**2;
            if (distance <= THRESHOLD**2) begin
                valid_path <= 1; // valid path found
            end else begin
                valid_path <= 0; // no valid path
            end
        end
    end
endmodule