module bellman_ford #(parameter N = 5) (
    input wire clk,
    input wire rst,
    input wire [N*N-1:0] adj_matrix, // adjacency matrix
    input wire [N-1:0] weights,        // weights of edges
    input wire [2:0] source,           // source node
    output reg [N-1:0] distance        // shortest distances
);
    integer i, j, k;
    reg [N-1:0] dist [0:N-1]; // distance array

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                dist[i] = (i == source) ? 0 : 8'd255; // Initialize distances
            end
        end else begin
            for (k = 0; k < N-1; k = k + 1) begin
                for (i = 0; i < N; i = i + 1) begin
                    for (j = 0; j < N; j = j + 1) begin
                        if (adj_matrix[i*N+j] && dist[i] + weights[i*N+j] < dist[j]) begin
                            dist[j] = dist[i] + weights[i*N+j];
                        end
                    end
                end
            end
            for (i = 0; i < N; i = i + 1) begin
                distance[i] = dist[i]; // Output shortest distances
            end
        end
    end
endmodule