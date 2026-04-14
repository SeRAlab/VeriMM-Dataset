module floyd_warshall #(
    parameter N = 4 // Number of vertices
)(
    input clk,
    input rst,
    input start,
    input [N*N-1:0] weights, // Flat representation of the weight matrix
    output reg [N*N-1:0] shortest_paths, // Flat representation of the resulting matrix
    output reg done
);
    reg [N*N-1:0] dist;
    integer i, j, k;
    reg [1:0] state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shortest_paths <= 0;
            dist <= weights;
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Initialization
                    if (start) begin
                        state <= 1;
                        done <= 0;
                        shortest_paths <= weights;
                    end
                end
                1: begin // Floyd-Warshall computation
                    for (k = 0; k < N; k = k + 1) begin
                        for (i = 0; i < N; i = i + 1) begin
                            for (j = 0; j < N; j = j + 1) begin
                                if (dist[i*N+j] > (dist[i*N+k] + dist[k*N+j])) begin
                                    dist[i*N+j] = dist[i*N+k] + dist[k*N+j];
                                end
                            end
                        end
                    end
                    state <= 2;
                end
                2: begin // Final output
                    shortest_paths <= dist;
                    done <= 1;
                    state <= 0; // reset state after completion
                end
            endcase
        end
    end
endmodule