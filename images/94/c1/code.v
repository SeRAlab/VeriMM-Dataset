module top_module(
    input       [ 2:0] block,
    input       [10:0] fnum,
    input signed [8:0] pm_offset,
    output reg  [16:0] phinc_pure
);reg [11:0] fnum_mod;

always @(*) begin 
    fnum_mod = {fnum,1'b0} + {{3{pm_offset[8]}},pm_offset};
    case ( block )
        3'd0: phinc_pure = { 7'd0, fnum_mod[11:2] };
        3'd1: phinc_pure = { 6'd0, fnum_mod[11:1] };
        3'd2: phinc_pure = { 5'd0, fnum_mod[11:0] };
        3'd3: phinc_pure = { 4'd0, fnum_mod, 1'd0 };
        3'd4: phinc_pure = { 3'd0, fnum_mod, 2'd0 };
        3'd5: phinc_pure = { 2'd0, fnum_mod, 3'd0 };
        3'd6: phinc_pure = { 1'd0, fnum_mod, 4'd0 };
        3'd7: phinc_pure = {       fnum_mod, 5'd0 };
    endcase
end

endmodule