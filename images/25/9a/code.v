module down_counter(  
    input clk,  
    input reset_n,  
    input load,  
    input [3:0] load_value,  
    output reg [3:0] count  
);  
    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            count <= 4'b0000;  
        end else if (load) begin  
            count <= load_value;  
        end else if (count > 4'b0000) begin  
            count <= count - 1;  
        end  
    end  
endmodule