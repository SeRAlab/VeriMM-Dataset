module top_module(
    input clk,
    input [8:0] addr,
    input [7:0] din,
    output [7:0] dout,
    input en,
    input we
);wire [7:0] mem_out;
    wire [7:0] mem_in = din;
    reg [7:0] dout_reg;
    
    // Declare the RAM module type here to avoid unknown module error.
    reg [7:0] ram [0:511]; // 512 x 8-bit RAM declaration

    always @(posedge clk) begin
        if (en) begin
            if (we) begin
                ram[addr] <= mem_in; // Write data to RAM
            end
            dout_reg <= ram[addr]; // Read data from RAM
        end
    end
    
    assign dout = dout_reg;

endmodule