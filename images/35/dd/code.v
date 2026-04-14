module down_counter (  
    input clk,  
    input reset,  
    input load,  
    input [3:0] preset,  
    output reg [3:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 4'b0000;  
        end else if (load) begin  
            count <= preset;  
        end else begin  
            if (count > 4'b0000) begin  
                count <= count - 1;  
            end  
        end  
    end  
endmodule