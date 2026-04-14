module top_module(
    input CLKIN,
    input RESETn,
    input BC_RELEASE_ISO,
    input SC_CLR_BUSY,
    input MBUS_CLR_BUSY,
    output reg BUS_BUSYn
);reg clr_busy_temp;
    
    always @ *
    begin
        if (BC_RELEASE_ISO == 1'b1)
            clr_busy_temp = 1'b0;
        else
            clr_busy_temp = MBUS_CLR_BUSY;
    end
    
    wire RESETn_BUSY = ((~clr_busy_temp) & (~SC_CLR_BUSY));
    
    always @ (negedge CLKIN or negedge RESETn or negedge RESETn_BUSY)
    begin
        if (~RESETn)
            BUS_BUSYn <= 1'b1;
        else if (~CLKIN)
            BUS_BUSYn <= 1'b0;
        else
            BUS_BUSYn <= 1'b1;
    end
    
endmodule