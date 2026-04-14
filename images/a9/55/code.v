module top_module(
    clk,
    in,
    load,
    address,
    out
 );input clk;             
    input [15:0] in;       
    input load;            
    input [15:0] address;  
    output [15:0] out;            
    
    reg [15:0] ram[0:24000]; 
    reg [15:0]value; 
    
    always @(posedge clk ) begin
        if (load) begin
            ram[address] <= in;
        end else begin
            value <= ram[address];
        end
    end
    
    assign out = value;
    
endmodule