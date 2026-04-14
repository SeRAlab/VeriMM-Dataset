module freq_divider (  
    input clk,  
    input rst,  
    output reg divided_clk  
);  
    reg [1:0] counter;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
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