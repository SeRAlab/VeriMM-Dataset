module interrupt_controller(  
    input wire clk,  
    input wire reset,  
    input wire interrupt_request,  
    input wire acknowledge,  
    output reg interrupt_pending  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            interrupt_pending <= 0;  
        end else begin  
            if (interrupt_request) begin  
                interrupt_pending <= 1;  
            end  
            if (acknowledge) begin  
                interrupt_pending <= 0;  
            end  
        end  
    end  
endmodule