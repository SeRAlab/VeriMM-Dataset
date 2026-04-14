module deadbeat_controller (  
    input clk,  
    input reset,  
    input [3:0] in_signal,  
    output reg [3:0] out_signal  
);  
    reg [3:0] temp_signal;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out_signal <= 4'b0000;  
            temp_signal <= 4'b0000;  
        end else begin  
            temp_signal <= in_signal;  
            out_signal <= temp_signal;  
        end  
    end  
endmodule