module top_module(
    input clk,
    input [12:0] addr,
    input [9:0] din,
    input we,
    output reg [9:0] dout
);reg [9:0] mem [0:8191]; // Example memory depth, adjust based on your needs

    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= din; // Write operation
        end
        dout <= mem[addr]; // Read operation
    end

endmodule