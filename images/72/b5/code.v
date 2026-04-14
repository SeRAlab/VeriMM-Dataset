module top_module(
    input [9:0] addr,
    input ce,
    input [31:0] d,
    input we,
    input clk,
    output reg [31:0] q
);parameter MEM_SIZE = 1024;
    reg [31:0] mem [MEM_SIZE-1:0];

    always @(posedge clk) begin
        if (ce) begin
            if (we) begin
                mem[addr] <= d;
            end else begin
                q <= mem[addr];
            end
        end
    end
    
endmodule