module top_module(
    input clk,
    input enable,
    input [11:0] addrA,
    input [11:0] addrB,
    input [11:0] addrW,
    input [8:0] dataIn,
    output reg [8:0] dataOutA,
    output reg [8:0] dataOutB
);// Assuming a simple RAM implementation
reg [8:0] ram [0:(1 << 12)-1]; // 12-bit addressable RAM with 9-bit data

always @(posedge clk) begin
    if (enable) begin
        if (addrW != 12'hXXX) // Write operation if addrW is valid
            ram[addrW] <= dataIn;
        
        dataOutA <= ram[addrA]; // Read from addrA
        dataOutB <= ram[addrB]; // Read from addrB
    end
end

endmodule