module top_module(
    Addr,
    Clk,
    Instr
    );parameter n = 5;
    input [n-1:0] Addr;
    input Clk;
    output reg [31:0] Instr;

    reg [31:0] ROM[2**n-1:0];
    
    
    integer i;
    always @(posedge Clk) begin
        Instr = ROM[Addr];
        
    end

    
    
    
    
endmodule