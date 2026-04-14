module watchdog_timer(  
    input clk,  
    input reset_n,  
    input [3:0] preset_value,  
    output reg timeout  
);  
    reg [3:0] counter;  

    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            counter <= preset_value;  
            timeout <= 0;  
        end else if (counter == 0) begin  
            timeout <= 1;  
        end else begin  
            counter <= counter - 1;  
            timeout <= 0;  
        end  
    end  
endmodule