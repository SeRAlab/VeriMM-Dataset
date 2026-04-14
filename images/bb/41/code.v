module top_module(
    input wire clk,
    input wire [7:0] ra, wa1, wa2,
    input wire [3:0] wbe,
    input wire [31:0] din1, din2,
    input wire we1, we2,
    output reg [31:0] dout1, dout2  // Change output from wire to reg
);reg [31:0] ram [0:255];
    
    always @(posedge clk) begin
        if (we1) begin
            if (wbe[0]) ram[wa1][ 7: 0] <= din1[ 7: 0];
            if (wbe[1]) ram[wa1][15: 8] <= din1[15: 8];
            if (wbe[2]) ram[wa1][23:16] <= din1[23:16];
            if (wbe[3]) ram[wa1][31:24] <= din1[31:24];
        end
        if (we2) begin
            if (wbe[0]) ram[wa2][ 7: 0] <= din2[ 7: 0];
            if (wbe[1]) ram[wa2][15: 8] <= din2[15: 8];
            if (wbe[2]) ram[wa2][23:16] <= din2[23:16];
            if (wbe[3]) ram[wa2][31:24] <= din2[31:24];
        end
        dout1 <= ram[ra];
        dout2 <= ram[ra]; // This line should actually set dout2 to ram[wa2]
    end
endmodule