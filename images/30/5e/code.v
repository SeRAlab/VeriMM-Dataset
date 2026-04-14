module crystal_oscillator(  
    input wire clk,  
    output reg out  
);  
    always @(posedge clk) begin  
        out <= ~out;  
    end  
endmodule