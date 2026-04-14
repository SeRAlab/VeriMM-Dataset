module top_module(
    input       [ 3:0]  mul,        
    input       [19:0]  phase_in,
    input               pg_rst,
    input signed [5:0]  detune_signed,
    input       [16:0]  phinc_pure,

    output reg  [19:0]  phase_out,
    output reg  [ 9:0]  phase_op
);reg [16:0] phinc_premul; 
reg [19:0] phinc_mul;

always @(*) begin
    phinc_premul = phinc_pure + {{11{detune_signed[5]}},detune_signed};
    phinc_mul    = ( mul==4'd0 ) ? {4'b0,phinc_premul[16:1]} : ({3'd0,phinc_premul} * mul);
    
    phase_out   = pg_rst ? 20'd0 : (phase_in + { phinc_mul});
    phase_op    = phase_out[19:10];
end

endmodule