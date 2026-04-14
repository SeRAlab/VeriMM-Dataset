module VCO (  
    input clk,  
    input reset,  
    input [3:0] V_ctl,  
    output reg [3:0] frequency_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            frequency_out <= 4'b0000;  
        else begin  
            // The output frequency is directly proportional to the control voltage  
            frequency_out <= V_ctl;  
        end  
    end  
endmodule