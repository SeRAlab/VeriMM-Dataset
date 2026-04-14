module UART_BRG(
    input   Rst,
    input   Clk,
    input   [3:0] PS,       
    input   [7:0] Div,      
    output  reg CE_16x      
);
    reg     [ 3:0] PSCntr;  
    reg     [ 7:0] Divider; 
    wire    TC_PSCntr;      
    wire    TC_Divider;     
always @(posedge Clk)
begin
    if(Rst)
        PSCntr <= #1 0;
    else if(TC_PSCntr)
        PSCntr <= #1 PS;
    else 
        PSCntr <= #1 PSCntr - 1;
end
assign TC_PSCntr = (PSCntr == 0);
always @(posedge Clk)
begin
    if(Rst)
        Divider <= #1 0;
    else if(TC_Divider)
        Divider <= #1 Div;
    else if(TC_PSCntr)
        Divider <= #1 Divider - 1;
end
assign TC_Divider = TC_PSCntr & (Divider == 0);
always @(posedge Clk)
begin    
    if(Rst)
        CE_16x <= #1 1'b0;
    else
        CE_16x <= #1 TC_Divider;
end
endmodule