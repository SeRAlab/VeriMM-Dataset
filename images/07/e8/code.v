module floyd_warshall(input [15:0] dist, output reg [15:0] updated_dist);  
    integer i, j, k;  
    reg [3:0] d [0:3][0:3];  

    always @* begin  
        // Initialize distance matrix from input  
        for (i = 0; i < 4; i = i + 1)  
            for (j = 0; j < 4; j = j + 1)  
                d[i][j] = (dist[(i*4+j)*4 +: 4] == 4'b1111) ? 4'b1111 : dist[(i*4+j)*4 +: 4];  

        // Floyd-Warshall algorithm  
        for (k = 0; k < 4; k = k + 1)  
            for (i = 0; i < 4; i = i + 1)  
                for (j = 0; j < 4; j = j + 1)  
                    if (d[i][k] != 4'b1111 && d[k][j] != 4'b1111)  
                        d[i][j] = (d[i][j] < d[i][k] + d[k][j]) ? d[i][j] : (d[i][k] + d[k][j]);  

        // Assemble updated distance matrix  
        for (i = 0; i < 4; i = i + 1)  
            for (j = 0; j < 4; j = j + 1)  
                updated_dist[(i*4+j)*4 +: 4] = d[i][j];  
    end  
endmodule