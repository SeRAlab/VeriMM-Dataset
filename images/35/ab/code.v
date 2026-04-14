module reset_controller (  
    input clk,  
    input rst_n,  
    output reg out  
);  
    reg [3:0] count;  
    parameter DURATION = 10; // Duration for which output should be held low  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            out <= 1'b0;  
            count <= 4'b0;  
        end else if (count < DURATION) begin  
            count <= count + 1;  
            out <= 1'b0;  
        end else begin  
            out <= 1'b1;  
        end  
    end  
endmodule