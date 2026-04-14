module rrt_acceptor (
    input clk,
    input reset,
    input [7:0] random_x,
    input [7:0] random_y,
    input [7:0] last_x,
    input [7:0] last_y,
    input [7:0] threshold,
    output reg [7:0] accepted_x,
    output reg [7:0] accepted_y,
    output reg accept_signal
);
    reg [15:0] distance_squared;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accepted_x <= 8'b0;
            accepted_y <= 8'b0;
            accept_signal <= 1'b0;
        end else begin
            // Calculate distance squared
            distance_squared <= (random_x - last_x)*(random_x - last_x) + (random_y - last_y)*(random_y - last_y);
            // Check if the distance is within the threshold
            if (distance_squared < (threshold * threshold)) begin
                accepted_x <= random_x;
                accepted_y <= random_y;
                accept_signal <= 1'b1; // Accepted
            end else begin
                accept_signal <= 1'b0; // Not accepted
            end
        end
    end
endmodule