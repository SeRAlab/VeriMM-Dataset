module johnson_counter (  
    input clk,  
    input rst_n,  
    output reg [4:0] q  
);  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            q <= 5'b00000;  
        else  
            q <= {~q[4], q[4:1]};  
    end  
endmodule