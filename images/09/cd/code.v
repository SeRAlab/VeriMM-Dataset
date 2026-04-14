module PLL_8x (  
    input wire clk_in,  
    input wire reset,  
    output reg clk_out  
);  
    reg [2:0] counter; // 3-bit counter to count up to 8  

    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            counter <= 3'b000;  
            clk_out <= 1'b0;  
        end else begin  
            if (counter == 3'b111) begin  
                clk_out <= ~clk_out; // Toggle output clock  
                counter <= 3'b000;  
            end else begin  
                counter <= counter + 1;  
            end  
        end  
    end  
endmodule