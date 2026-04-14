module rng(clk, reset, seed, output_r);  
    input clk;  
    input reset;  
    input [2:0] seed;  
    output reg [4:0] output_r;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            output_r <= {2'b00, seed};  
        else  
            output_r <= {output_r[3:0], output_r[4] ^ output_r[2]};  
    end  
endmodule