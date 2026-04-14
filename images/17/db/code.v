module FloydWarshall #(parameter N = 4) (  
    input clk,  
    input reset,  
    input [N*N-1:0] adjacency_matrix,  
    output reg [N*N-1:0] shortest_paths  
);  

reg [N*N-1:0] current_paths;  
integer i, j, k;  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        current_paths <= adjacency_matrix;  
        shortest_paths <= adjacency_matrix;  
    end else begin  
        for (k = 0; k < N; k = k + 1) begin  
            for (i = 0; i < N; i = i + 1) begin  
                for (j = 0; j < N; j = j + 1) begin  
                    if (current_paths[i*N + k] + current_paths[k*N + j] < current_paths[i*N + j]) begin  
                        shortest_paths[i*N + j] <= current_paths[i*N + k] + current_paths[k*N + j];  
                    end  
                end  
            end  
            current_paths <= shortest_paths;  
        end  
    end  
end  
endmodule