module dijkstra_shortest_path(
    input [3:0] weight_0_1, // weight from node 0 to node 1
    input [3:0] weight_1_2, // weight from node 1 to node 2
    input [3:0] weight_0_2, // direct weight from node 0 to node 2
    output reg [3:0] shortest_distance // output the shortest distance from node 0 to node 2
);
    always @(*) begin
        // Calculate the shortest distance from node 0 to node 2
        shortest_distance = (weight_0_2 < (weight_0_1 + weight_1_2)) ? weight_0_2 : (weight_0_1 + weight_1_2);
    end
endmodule