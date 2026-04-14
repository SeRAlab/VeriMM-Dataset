module top_module(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);reg [1023:0] shifted_in;

always @(*) begin
    case(sel)
        8'h00: shifted_in = in;
        8'h01: shifted_in = {in[1023:768], in[767:0]};
        8'h02: shifted_in = {in[1023:512], in[511:0]};
        8'h03: shifted_in = {in[1023:256], in[255:0]};
        8'h04: shifted_in = {in[1023:128], in[127:0]};
        8'h05: shifted_in = {in[1023:64], in[63:0]};
        8'h06: shifted_in = {in[1023:32], in[31:0]};
        8'h07: shifted_in = {in[1023:16], in[15:0]};
        8'h08: shifted_in = {in[1023:8], in[7:0]};
        8'h09: shifted_in = {in[1023:4], in[3:0], 12'h0};
        8'h0A: shifted_in = {in[1023:2], in[1:0], 14'h0};
        8'h0B: shifted_in = {in[1023:1], in[0], 15'h0};
        8'h0C: shifted_in = {in[1023], 15'h0};
        8'h0D: shifted_in = 16'h0;
        8'h0E: shifted_in = 14'h0;
        8'h0F: shifted_in = 12'h0;
        default: shifted_in = 16'h0;
    endcase
end

assign out = shifted_in[3:0];

endmodule