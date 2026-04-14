module bellman_ford #(parameter N = 5, M = 10) (
    input [N-1:0] src,  // source vertex
    input [M*2-1:0] edges, // edges represented as pairs (u, v) and weights
    output reg [N*8-1:0] dist // output distances
);
    integer i, j, u, v, w;
    reg [N*8-1:0] temp_dist;

    initial begin
        // Initialize distances
        for (i = 0; i < N; i = i + 1) begin
            if (i == src) 
                dist[i*8 +: 8] = 0; // Distance to source is 0
            else 
                dist[i*8 +: 8] = 8'hFF; // Infinity
        end

        // Relax edges (N-1) times
        for (i = 0; i < N-1; i = i + 1) begin
            temp_dist = dist;
            for (j = 0; j < M; j = j + 1) begin
                u = edges[j*3 +: 8]; // source of edge
                v = edges[j*3 + 8 +: 8]; // destination of edge
                w = edges[j*3 + 16 +: 8]; // weight of edge
                if (temp_dist[u*8 +: 8] + w < temp_dist[v*8 +: 8]) begin
                    temp_dist[v*8 +: 8] = temp_dist[u*8 +: 8] + w;
                end
            end
            dist = temp_dist;
        end
    end
endmodule