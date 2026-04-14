module bellman_ford #(parameter NUM_VERTICES = 5, parameter NUM_EDGES = 10) (
    input clk,
    input rst,
    input [NUM_EDGES*16-1:0] edges, // edges in the format [source, target, weight]
    input [3:0] source, // source vertex
    output reg [NUM_VERTICES*16-1:0] distances // shortest distances
);
    reg [NUM_VERTICES*16-1:0] dist_next;
    integer i, j;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            distances <= {NUM_VERTICES{16'hFFFF}}; // initialize distances to infinity
            distances[source*16 +: 16] <= 16'h0000; // distance to source is 0
        end else begin
            dist_next = distances;
            for (i = 0; i < NUM_VERTICES-1; i = i + 1) begin
                for (j = 0; j < NUM_EDGES; j = j + 1) begin
                    if (distances[edges[j*48 +: 16]] + edges[j*48 + 16 +: 16] < dist_next[edges[j*48 + 16 +: 16]]) begin
                        dist_next[edges[j*48 + 16 +: 16]] <= distances[edges[j*48 +: 16]] + edges[j*48 + 16 +: 16];
                    end
                end
            end
            distances <= dist_next; // update distances
        end
    end
endmodule