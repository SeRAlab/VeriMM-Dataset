module top_module(
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input [4:0] EX_rt,
    input EX_ramtoreg,
    output load_use_hazard
);assign load_use_hazard = EX_rt != 0 && EX_ramtoreg && (EX_rt == ID_rs || EX_rt == ID_rt);
    
endmodule