module top_module(
input						HCLK,
input						HRESETN,
input						DEFSLAVEDATASEL,
output	reg					DEFSLAVEDATAREADY,
output	reg					HRESP_DEFAULT
);localparam IDLE				= 1'b0;
localparam HRESPEXTEND		= 1'b1;
reg							defSlaveSMNextState;
reg							defSlaveSMCurrentState;
    always @ ( * )
    begin
        DEFSLAVEDATAREADY = 1'b1;
        HRESP_DEFAULT = 1'b0;
        case ( defSlaveSMCurrentState )
        IDLE:
        begin
            if ( DEFSLAVEDATASEL )
            begin
                DEFSLAVEDATAREADY = 1'b0;
                HRESP_DEFAULT = 1'b1;
                defSlaveSMNextState = HRESPEXTEND;
            end
            else
                defSlaveSMNextState = IDLE;
        end
        HRESPEXTEND:
        begin
            HRESP_DEFAULT = 1'b1;
            defSlaveSMNextState = IDLE;
        end
        default:
            defSlaveSMNextState = IDLE;
        endcase
    end
    always @ ( posedge HCLK or negedge HRESETN )
    begin
        if ( !HRESETN )
            defSlaveSMCurrentState <= IDLE;
        else
            defSlaveSMCurrentState <= defSlaveSMNextState;
    end
endmodule