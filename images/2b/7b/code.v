module interrupt_controller(  
    input wire clk,  
    input wire reset,  
    input wire ext_interrupt_req,  
    input wire ext_interrupt_en,  
    input wire timer_interrupt_req,  
    input wire timer_interrupt_en,  
    output reg interrupt  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        interrupt <= 0;  
    end else begin  
        if (ext_interrupt_req && ext_interrupt_en) begin  
            interrupt <= 1;  
        end else if (timer_interrupt_req && timer_interrupt_en) begin  
            interrupt <= 1;  
        end else begin  
            interrupt <= 0;  
        end  
    end  
end  
endmodule