module top_module(nrst, clk, bitcnt, sig_last, sig_tc);input nrst;
    input clk;
    input [2:0] bitcnt;
    output sig_last;
    output sig_tc;
    
    reg bits7_r;
    wire bits7;
    
    assign bits7 = (bitcnt == 3'b111);
    
    always @(posedge clk or negedge nrst) begin
        if (~nrst) begin
            bits7_r <= 1'b0;
        end else begin
            bits7_r <= bits7;
        end
    end
    
    assign sig_tc = ({bits7_r, bits7} == 2'b10);
    assign sig_last = ({bits7_r, bits7} == 2'b01);
endmodule