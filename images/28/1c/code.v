module watchdog_timer(  
    input wire clk,  
    input wire update,  
    input wire [3:0] timeout,  
    output reg reset  
);  
    reg [3:0] counter;  

    always @(posedge clk) begin  
        if (update)  
            counter <= timeout;  
        else if (counter > 0)  
            counter <= counter - 1;  

        reset <= (counter == 0);  
    end  
endmodule