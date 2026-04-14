module watchdog_timer(  
    input clk,  
    input reset_n,  
    input start,  
    input refresh,  
    input [3:0] timeout_value,  
    output reg reset_out  
);  
    reg [3:0] counter;  
    reg active;  
   
    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            counter <= 0;  
            reset_out <= 1;  
            active <= 0;  
        end  
        else if (start) begin  
            active <= 1;  
            counter <= 0;  
            reset_out <= 1;  
        end  
        else if (active) begin  
            if (refresh) begin  
                counter <= 0;  
                reset_out <= 1;  
            end  
            else begin  
                if (counter < timeout_value)  
                    counter <= counter + 1;  
                else  
                    reset_out <= 0;  
            end  
        end  
    end  
endmodule