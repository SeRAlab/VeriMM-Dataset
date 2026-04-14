module interrupt_controller(  
    input clk,  
    input reset,  
    input [2:0] irq_requests,  
    output reg [2:0] irq_processed  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            irq_processed <= 3'b000;  
        end else begin  
            if (irq_requests[2])  
                irq_processed <= 3'b100; // High priority  
            else if (irq_requests[1])  
                irq_processed <= 3'b010; // Medium priority  
            else if (irq_requests[0])  
                irq_processed <= 3'b001; // Low priority  
            else  
                irq_processed <= 3'b000; // No interrupt  
        end  
    end  
endmodule