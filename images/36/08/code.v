module graph_coloring(input [4:0] edges, output reg [2:0] colors);  
  integer i, j;  
  reg [2:0] temp_colors [4:0];  
  initial begin  
    for (i = 0; i < 5; i = i + 1)  
      temp_colors[i] = 3'b000;  
    for (i = 0; i < 5; i = i + 1) begin  
      if (temp_colors[i] == 3'b000) begin  
        temp_colors[i] = 3'b001;  
        for (j = 0; j < 5; j = j + 1) begin  
          if (edges[i*5 + j] == 1)  
            temp_colors[j] = (temp_colors[j] == 3'b001) ? 3'b010 : 3'b001;  
        end  
      end  
    end  
    colors = {temp_colors[0], temp_colors[1], temp_colors[2], temp_colors[3], temp_colors[4]};  
  end  
endmodule