module top_module(
    input [31:0] in,
    output reg [31:0] out);// Change 'output' to 'output reg'
    
    reg [7:0] shift_reg [0:3];
    
    always @(*) begin
        shift_reg[0] = in[31:24];
        shift_reg[1] = in[23:16];
        shift_reg[2] = in[15:8];
        shift_reg[3] = in[7:0];
        out = {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
    end
    
endmodule