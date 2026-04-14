module rrt_node_selector (  
    input clk,  
    input rst,  
    input [2:0] node_id,  
    output reg [2:0] selected_node  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            selected_node <= 3'b000;  
        else  
            selected_node <= (node_id == 3'b111) ? 3'b000 : node_id + 1;  
    end  
endmodule