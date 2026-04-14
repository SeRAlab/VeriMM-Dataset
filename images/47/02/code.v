module top_module(
    input clk,
    input [47:0] wline,
    output [47:0] rline,
    input [15:0] addr,
    input [1:0] rw
);reg [47:0] mem [255:0];
    
    assign rline = mem[addr];
    
    always @(posedge clk) begin
        if (rw == 2'b10) begin
            mem[addr] <= wline;
        end
    end
    
endmodule