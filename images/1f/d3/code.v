module watchdog_timer(  
    input clk,  
    input reset,  
    input tick,  
    output reg timeout  
);  
    reg [2:0] timer_count; // 3-bit timer count to reach 8  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            timer_count <= 3'b000;  
            timeout <= 1'b0;  
        end else if (tick) begin  
            if (timer_count < 3'b111) begin  
                timer_count <= timer_count + 1;  
            end  
            if (timer_count == 3'b111) begin  
                timeout <= 1'b1;  
            end  
        end  
    end  
endmodule