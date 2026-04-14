module crystal_oscillator (  
    input wire clk_in,  
    input wire [3:0] div_factor,  
    output reg clk_out  
);  
    reg [3:0] counter;  
     
    always @(posedge clk_in) begin  
        if (counter == div_factor) begin  
            clk_out <= ~clk_out;  
            counter <= 4'b0000;  
        end else begin  
            counter <= counter + 1;  
        end  
    end  
endmodule