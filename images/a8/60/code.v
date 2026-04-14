module top_module(
    input clk,
    input [31:0] data,
    input [4:0] rdaddress,
    input [4:0] wraddress,
    input wren,
    output reg [31:0] q
);reg [31:0] mem [0:31];  // Changed wire to reg
    
    always @(posedge clk) begin
        if (wren) begin
            mem[wraddress] <= data;  // This is valid now as mem is reg
        end
        q <= mem[rdaddress];
    end
    
endmodule