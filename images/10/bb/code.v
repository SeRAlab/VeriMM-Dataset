module clock_divider(  
    input clk,  
    input reset,  
    output reg clk_out  
);  
    reg [1:0] count;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 2'b00;  
            clk_out <= 0;  
        end else begin  
            count <= count + 1;  
            if (count == 2'b01) begin  
                clk_out <= ~clk_out;  
            end  
        end  
    end  
endmodule