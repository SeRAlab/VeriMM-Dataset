module dcfifo_fefifo  ( usedw_in, wreq, rreq, clock, aclr,
                        empty, full);
    parameter lpm_widthad = 1;
    parameter lpm_numwords = 1;
    parameter underflow_checking = "ON";
    parameter overflow_checking = "ON";
    parameter lpm_mode = "READ";
    input [lpm_widthad-1:0] usedw_in;
    input wreq, rreq;
    input clock;
    input aclr;
    output empty, full;
    reg [1:0] sm_empty;
    reg lrreq;
    reg i_empty, i_full;
    integer almostfull;
    initial
    begin
        if ((lpm_mode != "READ") && (lpm_mode != "WRITE"))
        begin
            $display ("Error! LPM_MODE must be READ or WRITE.");
            $display ("Time: %0t  Instance: %m", $time);
        end
        if ((underflow_checking != "ON") && (underflow_checking != "OFF"))
        begin
            $display ("Error! UNDERFLOW_CHECKING must be ON or OFF.");
            $display ("Time: %0t  Instance: %m", $time);
        end
        if ((overflow_checking != "ON") && (overflow_checking != "OFF"))
        begin
            $display ("Error! OVERFLOW_CHECKING must be ON or OFF.");
            $display ("Time: %0t  Instance: %m", $time);
        end
        sm_empty <= 2'b00;
        i_empty <= 1'b1;
        i_full <= 1'b0;
        if (lpm_numwords >= 3)
            almostfull <= lpm_numwords - 3;
        else
            almostfull <= 0;
    end
    always @(posedge aclr)
    begin
        sm_empty <= 2'b00;
        i_empty <= 1'b1;
        i_full <= 1'b0;
        lrreq <= 1'b0;
    end 
    always @(posedge clock)
    begin
        if (underflow_checking == "OFF")
            lrreq <= rreq;
        else
            lrreq <= rreq && ~i_empty;
        if (~aclr && $time > 0)
        begin
            if (lpm_mode == "READ")
            begin
                casex (sm_empty)
                    2'b00:
                        if (usedw_in != 0)
                            sm_empty <= 2'b01;
                    2'b01:
                        if (rreq && (((usedw_in == 1) && !lrreq) || ((usedw_in == 2) && lrreq)))
                            sm_empty <= 2'b10;
                    2'b10:
                        if (usedw_in > 1)
                            sm_empty <= 2'b01;
                        else
                            sm_empty <= 2'b00;
                    default:
                        $display ("Error! Invalid sm_empty state in read mode.");
                endcase
            end 
            else if (lpm_mode == "WRITE")
            begin
                casex (sm_empty)
                    2'b00:
                        if (wreq)
                            sm_empty <= 2'b01;
                    2'b01:
                        if (!wreq)
                            sm_empty <= 2'b11;
                    2'b11:
                        if (wreq)
                            sm_empty <= 2'b01;
                        else if (usedw_in == 0)
                            sm_empty <= 2'b00;
                    default:
                        $display ("Error! Invalid sm_empty state in write mode.");
                endcase
            end 
            if (~aclr && (usedw_in >= almostfull) && ($time > 0))
                i_full <= 1'b1;
            else
                i_full <= 1'b0;
        end 
    end 
    always @(sm_empty)
    begin
        i_empty <= !sm_empty[0];
    end
    assign empty = i_empty;
    assign full = i_full;
endmodule