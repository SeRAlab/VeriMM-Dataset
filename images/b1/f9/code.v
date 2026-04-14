module top_module(
    input clk,
    input [7:0] reset,      // Synchronous reset
    input [7:0] d,
    output [7:0] q
);reg [7:0] q_reg;
wire [7:0] sum;

always @(negedge clk) begin
    if (reset[0]) q_reg[0] <= 1'b0;
    else q_reg[0] <= d[0];
    
    if (reset[1]) q_reg[1] <= 1'b0;
    else q_reg[1] <= d[1];
    
    if (reset[2]) q_reg[2] <= 1'b0;
    else q_reg[2] <= d[2];
    
    if (reset[3]) q_reg[3] <= 1'b0;
    else q_reg[3] <= d[3];
    
    if (reset[4]) q_reg[4] <= 1'b0;
    else q_reg[4] <= d[4];
    
    if (reset[5]) q_reg[5] <= 1'b0;
    else q_reg[5] <= d[5];
    
    if (reset[6]) q_reg[6] <= 1'b0;
    else q_reg[6] <= d[6];
    
    if (reset[7]) q_reg[7] <= 1'b0;
    else q_reg[7] <= d[7];
end

assign sum = q_reg[0] + q_reg[1] + q_reg[2] + q_reg[3] + q_reg[4] + q_reg[5] + q_reg[6] + q_reg[7];

assign q = sum;

endmodule