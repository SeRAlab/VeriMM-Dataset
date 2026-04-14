module top_module(
    input wire [7:0] cmd,
    output wire nop,
    output wire special,
    output wire we,
    output wire [7:0] nrep,
    output wire target_nkmdprom,
    output wire target_csr,
    output wire [3:0] addr_high);assign we = cmd[7];

function [7:0] decode_nrep(
    input [1:0] enc);
begin
    case (enc)
        2'b00: decode_nrep = 8'd0;
        2'b01: decode_nrep = 8'd1;
        2'b10: decode_nrep = 8'd4;
        2'b11: decode_nrep = 8'd16;
    endcase
end
endfunction

assign nrep = decode_nrep(cmd[6:5]);

assign nop = cmd[6:5] == 2'b00 && cmd[3:0] != 4'hf;
assign target_nkmdprom = cmd[4] == 1'b1;
assign target_csr = cmd[4] == 1'b0;
assign special = cmd[6:5] == 2'b00 && cmd[3:0] == 4'hf;

assign addr_high = cmd[3:0];

endmodule