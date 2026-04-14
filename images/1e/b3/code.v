module prim_mst #(parameter N = 5) (  
    input wire [N*N-1:0] adj_matrix,  
    output reg [N*N-1:0] mst_edges  
);  
    integer i, j, k;  
    reg [N-1:0] in_mst;  
    reg [N-1:0] min_edge_weight;  
    reg [N-1:0] selected;  
    reg [N-1:0] edges;  
    reg [31:0] min_weight;  

    initial begin  
        in_mst = 0;  
        mst_edges = 0;  
        selected = 0;  
        
        in_mst[0] = 1; // Start from vertex 0  
        for (k = 0; k < N-1; k = k + 1) begin  
            min_weight = 32'hFFFFFFFF;  
            for (i = 0; i < N; i = i + 1) begin  
                if (in_mst[i]) begin  
                    for (j = 0; j < N; j = j + 1) begin  
                        if (!in_mst[j] && adj_matrix[i*N + j] > 0 && adj_matrix[i*N + j] < min_weight) begin  
                            min_weight = adj_matrix[i*N + j];  
                            selected = j;  
                        end  
                    end  
                end  
            end  
            in_mst[selected] = 1;  
            edges = (min_weight << (selected * 5)); // Store edge weight  
            mst_edges = mst_edges | edges;  
        end  
    end  
endmodule