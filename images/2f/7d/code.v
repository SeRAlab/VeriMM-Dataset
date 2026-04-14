module lfsr(clk, reset, seed, output_lfsr);  
    input clk;  
    input reset;  
    input [3:0] seed;  
    output reg [3:0] output_lfsr;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            output_lfsr <= seed;  
        else  
            output_lfsr <= {output_lfsr[2:0], output_lfsr[3] ^ output_lfsr[2]};  
    end  
endmodule