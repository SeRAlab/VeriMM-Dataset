module top_module(UNEXTENDED,EXTNDED_SHIFT);input [7:0] UNEXTENDED;
    output reg[31:0] EXTNDED_SHIFT;

    
    always @(*)
    begin
         EXTNDED_SHIFT = { {24{UNEXTENDED[7]}}, UNEXTENDED };
         EXTNDED_SHIFT = {EXTNDED_SHIFT[29:0],2'b00 };       
    end
endmodule