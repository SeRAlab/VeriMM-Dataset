module top_module(
    input [15:0] bcd_in,
    input clk,                // Added clk input
    output reg [3:0] binary_out
);reg [3:0] counter [3:0];
reg [3:0] temp [2:0];

always @ (posedge clk) begin
    // Stage 1
    temp[0] <= bcd_in[3:0];
    temp[1] <= bcd_in[7:4];
    temp[2] <= bcd_in[11:8];
    
    // Stage 2
    counter[0] <= (counter[0] == 4'b1001) ? 4'b0000 : counter[0] + 1'b1;
    counter[1] <= (counter[1] == 4'b1001) ? 4'b0000 : counter[1] + 1'b1;
    counter[2] <= (counter[2] == 4'b1001) ? 4'b0000 : counter[2] + 1'b1;
    counter[3] <= (counter[3] == 4'b1001) ? 4'b0000 : counter[3] + 1'b1;
    
    // Stage 3
    binary_out[0] <= (temp[0] >= counter[0]) ? 1'b1 : 1'b0;
    binary_out[1] <= (temp[1] >= counter[1]) ? 1'b1 : 1'b0;
    binary_out[2] <= (temp[2] >= counter[2]) ? 1'b1 : 1'b0;
    binary_out[3] <= (bcd_in[15] >= counter[3]) ? 1'b1 : 1'b0;
end

endmodule