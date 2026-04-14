module top_module(
    input ExtSel,
    input [15:0] ime,
    output reg [31:0] exten
);always @( ExtSel or ime) begin
        if(ExtSel == 1 && ime[15] == 1) exten = {16'hffff, ime};
        else exten = {16'h0000, ime};
    end
endmodule