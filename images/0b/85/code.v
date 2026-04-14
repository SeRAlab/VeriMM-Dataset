module k_means_cluster (
    input [4:0] point1,
    input [4:0] point2,
    input [4:0] point3,
    output [4:0] cluster_center
);
    assign cluster_center = (point1 + point2 + point3) / 3;
endmodule