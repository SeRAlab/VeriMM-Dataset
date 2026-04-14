module floyd_warshall #(parameter N = 4) (
    input clk,
    input reset,
    input [N*N*16-1:0] weights, // 16-bit weights for edges
    output reg [N*N*16-1:0] shortest_paths // 16-bit shortest paths
);
    reg [N*N*16-1:0] current_paths;
    reg [N-1:0] k;
    
    integer i, j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shortest_paths <= weights;
            current_paths <= weights;
            k <= 0;
        end else if (k < N) begin
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    current_paths[i*N+j] <= (current_paths[i*N+j] < (current_paths[i*N+k] + current_paths[k*N+j])) ?
                      current_paths[i*N+j] : (current_paths[i*N+k] + current_paths[k*N+j]);
                end
            end
            shortest_paths <= current_paths;
            k <= k + 1;
        end
    end
endmodule