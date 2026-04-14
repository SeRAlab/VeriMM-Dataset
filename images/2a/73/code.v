module floyd_warshall #(parameter N = 4)(  
    input clk,  
    input rst,  
    input [N*N*8-1:0] weight_matrix,  
    output reg [N*N*8-1:0] dist_matrix  
);  
    reg [N*N*8-1:0] dist;  
    integer k, i, j;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dist <= weight_matrix;  
        end else begin  
            for (k = 0; k < N; k = k + 1) begin  
                for (i = 0; i < N; i = i + 1) begin  
                    for (j = 0; j < N; j = j + 1) begin  
                        if (dist[i*N*8 + k*8 +: 8] + dist[k*N*8 + j*8 +: 8] < dist[i*N*8 + j*8 +: 8]) begin  
                            dist[i*N*8 + j*8 +: 8] <= dist[i*N*8 + k*8 +: 8] + dist[k*N*8 + j*8 +: 8];  
                        end  
                    end  
                end  
            end  
            dist_matrix <= dist;  
        end  
    end  
endmodule