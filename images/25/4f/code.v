module reset_controller(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] duration,  
    output reg rst_out  
);  
    reg [3:0] counter;  
    reg active;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            rst_out <= 1;  
            counter <= duration;  
            active <= 1;  
        end else if (active) begin  
            if (counter > 0) begin  
                counter <= counter - 1;  
            end else begin  
                rst_out <= 0;  
                active <= 0;  
            end  
        end  
    end  
endmodule