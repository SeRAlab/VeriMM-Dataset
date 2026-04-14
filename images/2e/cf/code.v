module watchdog_timer(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] preset_value,  
    output reg timeout  
);  
    reg [3:0] count;  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= preset_value;  
            timeout <= 0;  
        end else if (count > 0) begin  
            count <= count - 1;  
            timeout <= 0;  
        end else begin  
            timeout <= 1;  
        end  
    end  
endmodule