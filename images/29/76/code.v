module interrupt_controller (  
    input clk,  
    input rst_n,  
    input enable_A,  
    input enable_B,  
    input interrupt_A,  
    input interrupt_B,  
    output reg ack_A,  
    output reg ack_B,  
    output reg processing_A,  
    output reg processing_B  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            ack_A <= 0;  
            ack_B <= 0;  
            processing_A <= 0;  
            processing_B <= 0;  
        end else begin  
            if (enable_A && interrupt_A && !processing_A) begin  
                ack_A <= 1;  
                processing_A <= 1;  
            end else if (ack_A) begin  
                ack_A <= 0;  
            end  
            
            if (enable_B && interrupt_B && !processing_B) begin  
                ack_B <= 1;  
                processing_B <= 1;  
            end else if (ack_B) begin  
                ack_B <= 0;  
            end  
            
            if (processing_A) begin  
                processing_A <= 0;  
            end  
            if (processing_B) begin  
                processing_B <= 0;  
            end  
        end  
    end  
endmodule