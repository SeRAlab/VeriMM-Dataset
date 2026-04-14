module top_module(
    input iCLK      ,
    input iRST      ,
    input iSIG      ,
    output wire oRE ,
    output wire oFE ,
    output wire oRFE
);parameter registered = "FALSE";

reg delay;

wire re;
wire fe;
wire rfe;


always @(posedge iCLK)
begin
    if (iRST)
    begin
        delay <= 1'b0;
    end
    else
    begin
        delay <= iSIG;
    end
end



assign re   = (iSIG && !delay) ? 1'b1 : 1'b0;
assign fe   = (!iSIG && delay) ? 1'b1 : 1'b0;
assign rfe  = ((iSIG && !delay) || (!iSIG && delay)) ? 1'b1 : 1'b0;



reg re_reg, fe_reg, rfe_reg;
always @(posedge iCLK)
begin
    if (iRST)
    begin
        re_reg     <= 1'b0;
        fe_reg     <= 1'b0;
        rfe_reg    <= 1'b0;
    end
    else
    begin
        re_reg     <= re;
        fe_reg     <= fe;
        rfe_reg    <= rfe;
    end
end



assign oRE =    (registered == "TRUE") ? re_reg  : re ;
assign oFE =    (registered == "TRUE") ? fe_reg  : fe ;
assign oRFE =   (registered == "TRUE") ? rfe_reg : rfe;


endmodule