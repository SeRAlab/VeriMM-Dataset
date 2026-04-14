module sample_rate_converter(  
    input wire clk_in,  
    input wire reset,  
    input wire enable,  
    output reg clk_out  
);  
    reg [1:0] counter;  
  
    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00;  
            clk_out <= 0;  
        end else if (enable) begin  
            counter <= counter + 1;  
            if (counter == 2'b01) begin  
                clk_out <= ~clk_out;  
            end  
        end  
    end  
endmodule