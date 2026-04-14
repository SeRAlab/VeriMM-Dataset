module top_module(
    input clk,
    input reset, // Added reset input
    input [31:0] in,
    output [31:0] out
);reg [31:0] in_reg;
reg [31:0] out_reg;
reg [31:0] out_hold;

always @(posedge clk) begin
    in_reg <= in;  // Update the in_reg before checking its value
    if (in_reg == 32'hFFFFFFFF) begin
        out_reg <= 32'h00000000;
    end else begin
        out_reg <= out_hold;
    end
end

assign out = out_reg;

genvar i;
generate
    for (i = 0; i < 31; i = i + 1) begin : bit_loop
        reg d_ff [1:0]; // Fixed declaration to be proper array of regs
        assign d_ff[0] = in_reg[i] ^ in_reg[i + 1]; // Check only valid indices
        assign d_ff[1] = d_ff[0] ^ 1'b1;
        
        always @(posedge clk or posedge reset) begin // Clear condition on reset
            if (reset) begin
                out_hold[i] <= 1'b0;
            end else if (d_ff[1]) begin
                out_hold[i] <= 1'b1;
            end
        end
    end
endgenerate

endmodule