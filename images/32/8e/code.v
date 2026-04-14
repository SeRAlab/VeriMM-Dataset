module frequency_divider(  
    input clk,  
    input reset,  
    output reg divided_clk  
);  
    reg [1:0] counter;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00;  
            divided_clk <= 1'b0;  
        end else begin  
            counter <= counter + 1;  
            if (counter == 2'b11) begin  
                divided_clk <= ~divided_clk;  
            end  
        end  
    end  
endmodule