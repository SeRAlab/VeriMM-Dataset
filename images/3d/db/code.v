module floyd_warshall (  
    input clk,  
    input reset,  
    input [7:0] dist_00,  
    input [7:0] dist_01,  
    input [7:0] dist_02,  
    input [7:0] dist_10,  
    input [7:0] dist_11,  
    input [7:0] dist_12,  
    input [7:0] dist_20,  
    input [7:0] dist_21,  
    input [7:0] dist_22,  
    output reg [7:0] out_00,  
    output reg [7:0] out_01,  
    output reg [7:0] out_02,  
    output reg [7:0] out_10,  
    output reg [7:0] out_11,  
    output reg [7:0] out_12,  
    output reg [7:0] out_20,  
    output reg [7:0] out_21,  
    output reg [7:0] out_22  
);  
    reg [7:0] dist [0:2][0:2];  
    integer i, j, k;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            dist[0][0] <= 8'h00;  
            dist[0][1] <= 8'hFF;  
            dist[0][2] <= 8'hFF;  
            dist[1][0] <= 8'hFF;  
            dist[1][1] <= 8'h00;  
            dist[1][2] <= 8'hFF;  
            dist[2][0] <= 8'hFF;  
            dist[2][1] <= 8'hFF;  
            dist[2][2] <= 8'h00;  
        end else begin  
            dist[0][0] <= dist_00;  
            dist[0][1] <= dist_01;  
            dist[0][2] <= dist_02;  
            dist[1][0] <= dist_10;  
            dist[1][1] <= dist_11;  
            dist[1][2] <= dist_12;  
            dist[2][0] <= dist_20;  
            dist[2][1] <= dist_21;  
            dist[2][2] <= dist_22;  

            for (k = 0; k < 3; k = k + 1) begin  
                for (i = 0; i < 3; i = i + 1) begin  
                    for (j = 0; j < 3; j = j + 1) begin  
                        if (dist[i][k] + dist[k][j] < dist[i][j]) begin  
                            dist[i][j] <= dist[i][k] + dist[k][j];  
                        end  
                    end  
                end  
            end  

            out_00 <= dist[0][0];  
            out_01 <= dist[0][1];  
            out_02 <= dist[0][2];  
            out_10 <= dist[1][0];  
            out_11 <= dist[1][1];  
            out_12 <= dist[1][2];  
            out_20 <= dist[2][0];  
            out_21 <= dist[2][1];  
            out_22 <= dist[2][2];  
        end  
    end  
endmodule