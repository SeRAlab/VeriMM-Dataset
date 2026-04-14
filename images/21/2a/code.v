module graph_coloring(
    input [3:0] nodes,   // 4-bit input for nodes
    output [3:0] colors  // 4-bit output for colors
);
    assign colors[0] = (nodes[0] || nodes[1]) ? 1'b0 : 1'b1; // Color for node 0
    assign colors[1] = (nodes[0] || nodes[2]) ? 1'b1 : 1'b0; // Color for node 1
    assign colors[2] = (nodes[1] || nodes[3]) ? 1'b0 : 1'b1; // Color for node 2
    assign colors[3] = (nodes[2] || nodes[3]) ? 1'b1 : 1'b0; // Color for node 3
endmodule