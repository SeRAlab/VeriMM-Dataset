module top_module(
    
    input             clk,        
    input             flag_A,
    input             flag_B,
    input             busy,
    input      [5:0]  adpcma_flags,
    input             adpcmb_flag,
    input      [7:0]  psg_dout,
    input      [1:0]  addr,
    output reg [7:0]  dout
);parameter use_ssg=0, use_adpcm=0;

always @(posedge clk) begin
    casez( addr )
        2'b00: dout <= {busy, 5'd0, flag_B, flag_A }; 
        2'b01: dout <= (use_ssg  ==1) ? psg_dout : {busy, 5'd0, flag_B, flag_A };
        2'b1?: dout <= (use_adpcm==1) ?
            { adpcmb_flag, 1'b0, adpcma_flags } :
            { busy, 5'd0, flag_B, flag_A };
    endcase
end

endmodule