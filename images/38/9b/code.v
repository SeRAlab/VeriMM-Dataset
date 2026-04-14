module vco (input wire ctrl, output reg clk);  
    always @(posedge ctrl) begin  
        clk <= ~clk;  
    end  
endmodule