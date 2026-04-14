module graph_coloring(input [4:0] edges, // Adjacency representation of graph  
                      output reg [2:0] colors); // Color assigned to the vertices  
  
    always @(*) begin  
        // Simple 3-coloring logic for a 5-node graph based on edges  
        case(edges)  
            5'b00000: colors = 3'b001; // No edges, color vertex 0 with color 1  
            5'b00001: colors = 3'b010; // Edge between vertex 0 and 1  
            5'b00010: colors = 3'b011; // Edge between vertex 0 and 2  
            5'b00100: colors = 3'b001; // Edge between vertex 0 and 3  
            5'b01000: colors = 3'b010; // Edge between vertex 0 and 4  
            default:  colors = 3'b000; // Default case  
        endcase  
    end  
endmodule