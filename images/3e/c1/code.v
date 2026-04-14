module crystal_oscillator (  
    input wire clk,  
    input wire enable,  
    output reg out  
);  
    always @(posedge clk) begin  
        if (enable)  
            out <= ~out;  
    end  
endmodule