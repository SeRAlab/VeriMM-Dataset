module Prim_MST #(parameter N = 5) (  
    input clk,  
    input rst,  
    input [N*N-1:0] adj_matrix,  
    output reg [N*N-1:0] mst_edges,  
    output reg done  
);  
    reg [N-1:0] selected;  
    reg [N-1:0] min_edge;  
    reg [N:0] min_cost;  
    integer i, j, count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            selected <= 0;  
            mst_edges <= 0;  
            done <= 0;  
            count <= 0;  
        end else if (count < N-1) begin  
            min_cost = 16'hFFFF;  
            for (i = 0; i < N; i = i + 1) begin  
                if (!selected[i]) begin  
                    for (j = 0; j < N; j = j + 1) begin  
                        if (selected[j] && adj_matrix[i*N+j] < min_cost) begin  
                            min_cost = adj_matrix[i*N+j];  
                            min_edge = {j, i};  
                        end  
                    end  
                end  
            end  
            selected[min_edge[N-1:0]] = 1;  
            mst_edges[min_edge[N:0]*N + min_edge[N-1:0]] = 1;  
            count = count + 1;  
            if (count == N-1) done <= 1;  
        end  
    end  
endmodule