module top_module(ifid_out, sign_ex_out);input [31:0] ifid_out;
    output [31:0] sign_ex_out;
    
    wire [15:0] imm = {ifid_out [15:0]};
    
    assign sign_ex_out = {{16{imm[15]}},imm[15:0]};
endmodule