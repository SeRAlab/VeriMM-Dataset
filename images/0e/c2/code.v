module pll(input wire clk_ref,  
           input wire clk_in,  
           output reg clk_out);  

    reg [1:0] phase;  
    reg [3:0] filter;  

    always @(posedge clk_in or posedge clk_ref) begin  
        if (clk_ref) begin  
            phase <= 2'b00;  
            filter <= 4'b0000;  
        end else begin  
            phase <= phase + 1;  
            filter <= filter + phase;  
            clk_out <= (filter[3]) ? ~clk_out : clk_out;  
        end  
    end  
endmodule