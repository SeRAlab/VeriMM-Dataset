module top_module(clk, we, w_addr, r_addr, d_in, d_out);parameter MEM_SIZE = 19200; 
    
    input clk;
    input we;
    
    input [14:0] w_addr;
    input [15:0] d_in;
    
    input [14:0] r_addr;
    output reg [15:0] d_out;
    
    reg [15:0] ram [MEM_SIZE-1:0]; 
    
    
    always @(posedge clk) begin
        if (we)
            ram[w_addr] <= d_in;
        d_out <= ram[r_addr];
    end
  
endmodule