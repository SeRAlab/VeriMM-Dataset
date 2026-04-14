module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] d, // 8-bit input for the register
    input a, // First input for the XNOR gate
    input b, // Second input for the XNOR gate
    output reg [7:0] reg_out, // 8-bit output from the register
    output xnor_out, // Output from the XNOR gate
    output final_out // Final output from the functional module
);// 8-bit register with active high synchronous reset
reg [7:0] my_reg;
always @(posedge clk) begin
    if (reset) begin
        my_reg <= 8'h34;
    end else begin
        my_reg <= d;
    end
end

assign reg_out = my_reg;

// XNOR gate module using only NAND gates
wire nand1_out, nand2_out, nand3_out, nand4_out;
nand nand1(nand1_out, a, b);
nand nand2(nand2_out, a, nand1_out);
nand nand3(nand3_out, b, nand1_out);
nand nand4(xnor_out, nand2_out, nand3_out);

// Functional module
wire same;
assign same = (my_reg == xnor_out);
assign final_out = same ? 1 : 0;

endmodule