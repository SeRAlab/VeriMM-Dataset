module top_module(
     input        CLK,
     input        RST,
     input [2:0]  CONFIG_MAX_READ_REQUEST_SIZE, 
     input [11:0] CONFIG_MAX_CPL_DATA, 
     input [7:0]  CONFIG_MAX_CPL_HDR, 
     input        CONFIG_CPL_BOUNDARY_SEL, 
     input        RX_ENG_RD_DONE, 
     input        TX_ENG_RD_REQ_SENT, 
     output       RXBUF_SPACE_AVAIL 
     );reg           rCreditAvail=0;
    reg           rCplDAvail=0;
    reg           rCplHAvail=0;
    reg [12:0]    rMaxRecv=0;
    reg [11:0]    rCplDAmt=0;
    reg [7:0]     rCplHAmt=0;
    reg [11:0]    rCplD=0;
    reg [7:0]     rCplH=0;

    reg           rInfHCred; 
    reg           rInfDCred; 
    

    assign RXBUF_SPACE_AVAIL = rCreditAvail;

    
    always @(posedge CLK) begin
        rInfHCred <= (CONFIG_MAX_CPL_HDR == 0);
        rInfDCred <= (CONFIG_MAX_CPL_DATA == 0);
        rMaxRecv <= #1 (13'd128<<CONFIG_MAX_READ_REQUEST_SIZE);
        rCplHAmt <= #1 (rMaxRecv>>({2'b11, CONFIG_CPL_BOUNDARY_SEL}));
        rCplDAmt <= #1 (rMaxRecv>>4);
        rCplHAvail <= #1 (rCplH <= CONFIG_MAX_CPL_HDR);
        rCplDAvail <= #1 (rCplD <= CONFIG_MAX_CPL_DATA);
        rCreditAvail <= #1 ((rCplHAvail|rInfHCred) & (rCplDAvail | rInfDCred));
    end

    
    always @ (posedge CLK) begin
        if (RST) begin
            rCplH <= #1 0;
            rCplD <= #1 0;
        end
        else if (RX_ENG_RD_DONE & TX_ENG_RD_REQ_SENT) begin
            rCplH <= #1 rCplH;
            rCplD <= #1 rCplD;
        end
        else if (TX_ENG_RD_REQ_SENT) begin
            rCplH <= #1 rCplH + rCplHAmt;
            rCplD <= #1 rCplD + rCplDAmt;
        end
        else if (RX_ENG_RD_DONE) begin
            rCplH <= #1 rCplH - rCplHAmt;
            rCplD <= #1 rCplD - rCplDAmt;
        end
    end

endmodule