module dijkstra_shortest_path (  
    input [8:0] adjacency_matrix,  // 9 bits for a 3x3 matrix  
    output reg [3:0] distances      // 4 bits for each distance, total 4 bits for 3 nodes  
);  
    reg [3:0] dist [0:2];  
    integer i, j;  
    initial begin  
        dist[0] = 0;  
        dist[1] = 4'b1111;  // Infinite  
        dist[2] = 4'b1111;  // Infinite  
    end  
    always @(*) begin  
        // Simple logic to simulate a single iteration of Dijkstra's algorithm  
        for (i = 0; i < 3; i = i + 1) begin  
            for (j = 0; j < 3; j = j + 1) begin  
                if (adjacency_matrix[i * 3 + j] != 1'b1 && (dist[i] + adjacency_matrix[i * 3 + j] < dist[j])) begin  
                    dist[j] = dist[i] + adjacency_matrix[i * 3 + j];  
                end  
            end  
        end  
        distances = {dist[0], dist[1], dist[2]};  
    end  
endmodule