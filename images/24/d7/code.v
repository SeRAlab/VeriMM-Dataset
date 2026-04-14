module NVMe_Command_Register (
    input wire clk,
    input wire [7:0] opcode,
    input wire [3:0] tag,
    output reg [7:0] stored_opcode,
    output reg [3:0] stored_tag
);

    always @(posedge clk) begin
        stored_opcode <= opcode;
        stored_tag <= tag;
    end
endmodule