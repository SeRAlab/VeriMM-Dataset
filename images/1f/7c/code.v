module kmeans_clustering (
    input clk,
    input reset,
    input [7:0] data_in, // Data point input
    input start,         // Start signal
    output reg [7:0] centroid_0, // Cluster centroid 0
    output reg [7:0] centroid_1, // Cluster centroid 1
    output reg done       // Done signal
);
    reg [1:0] state, next_state;
    reg [7:0] sum_0, sum_1, count_0, count_1;
    parameter IDLE = 2'b00, UPDATE = 2'b01, CONVERGE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            centroid_0 <= 8'd0;
            centroid_1 <= 8'd0;
            sum_0 <= 8'd0;
            sum_1 <= 8'd0;
            count_0 <= 8'd0;
            count_1 <= 8'd0;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = UPDATE;
                end else begin
                    next_state = IDLE;
                end
            end
            UPDATE: begin
                if (data_in < centroid_0) begin
                    sum_0 = sum_0 + data_in;
                    count_0 = count_0 + 1;
                end else begin
                    sum_1 = sum_1 + data_in;
                    count_1 = count_1 + 1;
                end
                next_state = CONVERGE;
            end
            CONVERGE: begin
                if (count_0 > 0) centroid_0 = sum_0 / count_0;
                if (count_1 > 0) centroid_1 = sum_1 / count_1;
                done = 1;
                next_state = IDLE; // Go back to IDLE after completion
            end
            default: next_state = IDLE;
        endcase
    end
endmodule