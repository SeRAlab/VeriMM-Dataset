module divide_by_4(  
    input clk,  
    input reset,  
    output reg out  
);  
    reg [1:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 2'b00;  
            out <= 1'b0;  
        end else begin  
            counter <= counter + 1;  
            out <= (counter == 2'b11) ? 1'b1 : 1'b0;  
        end  
    end  
endmodule