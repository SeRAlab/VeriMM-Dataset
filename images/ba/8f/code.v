module top_module(
 input     de_clk,
 input     de_rstn,
 input     d_busy,
 input     cmdrdy,
 input     pcbusy,
 input     line_actv_1,
 input     blt_actv_1,
 input     noop_actv_2,

 output reg    goline,
 output reg    goblt,
 output reg    d_cmdack,
 output reg    d_cmdcpyclr,
 output reg    load_actvn,
 // For test only.
 output reg    [1:0] d_cs
 );/****************************************************************/
/*          DEFINE PARAMETERS         */
/****************************************************************/
/* define state parameters */
parameter
    IDLE=2'b00,
    DECODE=2'b01,
    BUSY=2'b10;

/* define internal wires and make assignments */
reg [1:0] d_ns;

/* create the state register */
always @(posedge de_clk or negedge de_rstn) 
    begin
        if(!de_rstn) d_cs <= 2'b0;
        else d_cs <= d_ns;
    end

reg igoblt;
reg igoline;
always @(posedge de_clk) goline <= igoline;
always @(posedge de_clk) goblt <= igoblt;

always @* begin
        d_cmdack=1'b0;
        d_cmdcpyclr=1'b0;
        load_actvn=1'b1;
        igoline=1'b0;
        igoblt=1'b0;
        case(d_cs)
            IDLE:   if(!cmdrdy || pcbusy) d_ns=IDLE;
                    else begin
                        load_actvn=1'b0;
                        d_cmdack=1'b1;
                        d_ns=DECODE;
                        if(line_actv_1) igoline=1'b1;
                        if(blt_actv_1)  igoblt=1'b1;
                    end

            DECODE: d_ns=BUSY;

            BUSY:   begin
                    if((noop_actv_2) || !d_busy)
                        begin
                        d_ns=IDLE;
                        d_cmdcpyclr=1'b1;
                        end
                    else d_ns=BUSY;
                    end
            default: begin
                        d_ns=IDLE;
                        d_cmdcpyclr=1'b0;
                        load_actvn=1'b1;
                        d_cmdack=1'b0;
                    end
        endcase
    end

endmodule