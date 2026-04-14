module pll_8x (  
    input wire clk_in,  
    input wire rst,  
    output reg clk_out  
);  
    reg [2:0] counter;  

    always @(posedge clk_in or posedge rst) begin  
        if (rst) begin  
            counter <= 3'b000;  
            clk_out <= 0;  
        end else begin  
            if (counter == 3'b111) begin  
                clk_out <= ~clk_out;  
                counter <= 3'b000;  
            end else begin  
                counter <= counter + 1;  
            end  
        end  
    end  
endmodule