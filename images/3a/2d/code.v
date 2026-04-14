module crystal_oscillator (  
    input wire clk_in,  
    input wire enable,  
    output reg clk_out  
);  
    reg [1:0] counter;  

    always @(posedge clk_in or negedge enable) begin  
        if (!enable) begin  
            clk_out <= 0;  
            counter <= 0;  
        end else begin  
            counter <= counter + 1;  
            if (counter == 2) begin  
                clk_out <= ~clk_out;  
                counter <= 0;  
            end  
        end  
    end  
endmodule