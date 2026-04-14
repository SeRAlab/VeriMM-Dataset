module interrupt_controller (  
    input clk,  
    input reset,  
    input int_req_high,  
    input int_req_low,  
    output reg int_ack  
);  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            int_ack <= 0;  
        end else begin  
            if (int_req_high) begin  
                int_ack <= 1;  
            end else if (int_req_low) begin  
                int_ack <= 0;  
            end else begin  
                int_ack <= 0;  
            end  
        end  
    end  
endmodule