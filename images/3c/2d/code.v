module down_counter (  
    input clk,  
    input rst_n,  
    input load,  
    input [3:0] load_value,  
    output reg [3:0] count  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            count <= 4'b0000;  
        else if (load)  
            count <= load_value;  
        else  
            count <= (count == 4'b0000) ? 4'b1111 : count - 1;  
    end  
endmodule