module timer_32bit (  
    input clk,  
    input reset,  
    input stop,  
    output reg [31:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 32'b0;  
        end else if (!stop) begin  
            count <= count + 1;  
        end  
    end  
endmodule