module watchdog_timer(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] timeout_limit,  
    output reg system_reset  
);  
    reg [3:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 4'd0;  
            system_reset <= 1'b0;  
        end else begin  
            if (counter < timeout_limit) begin  
                counter <= counter + 1;  
                system_reset <= 1'b0;  
            end else begin  
                system_reset <= 1'b1;  
            end  
        end  
    end  
endmodule