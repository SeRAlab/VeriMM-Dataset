module top_module(
    input [3:0] in,
    input [1:0] sel,
    input enable,
    input clk,             // Added clk input
    output reg out         // Changed output to reg type
);reg [3:0] pipeline_reg1;
reg [3:0] pipeline_reg2;
reg [3:0] pipeline_reg3;

always @(posedge clk) begin
    pipeline_reg1 <= in;
    pipeline_reg2 <= pipeline_reg1;
    pipeline_reg3 <= pipeline_reg2;
end

always @(*) begin
    if (enable) begin
        case(sel)
            2'b00: out = pipeline_reg1[0]; // assuming you want one bit as output
            2'b01: out = pipeline_reg2[0];
            2'b10: out = pipeline_reg3[0];
            2'b11: out = in[0];
            default: out = 1'b0; // Optional default case
        endcase
    end else begin
        out = 1'bz; // keep output high impedance when not enabled
    end
end

endmodule