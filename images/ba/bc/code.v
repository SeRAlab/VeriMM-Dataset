module top_module(
    input clk,
    input en,
    input we,
    input [11:0] addr,
    input [7:0] din,
    output reg [7:0] dout
);// Declare the memory array (assumed size for example)
    reg [7:0] memory_array [0:4095]; // 4096 x 8-bit memory

    always @(posedge clk) begin
        if (en) begin
            if (we) begin
                memory_array[addr] <= din; // Write operation
            end
            dout <= memory_array[addr]; // Read operation
        end
    end

endmodule