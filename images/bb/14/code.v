module top_module(
    input SCE,
    input GATE,
    input CLK,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg GCLK
);reg [1:0] state;
    parameter IDLE = 2'b00;
    parameter RISE = 2'b01;
    parameter FALL = 2'b10;
    parameter HIGH = 2'b11;
    
    always @ (posedge CLK) begin
        if (SCE) begin
            case (state)
                IDLE: begin
                    if (GATE) begin
                        state <= RISE;
                        GCLK <= 1'b0;
                    end else begin
                        GCLK <= 1'b0;
                    end
                end
                RISE: begin
                    state <= HIGH;
                    GCLK <= 1'b1;
                end
                HIGH: begin
                    if (!GATE) begin
                        state <= FALL;
                        GCLK <= 1'b1;
                    end else begin
                        GCLK <= 1'b1;
                    end
                end
                FALL: begin
                    state <= IDLE;
                    GCLK <= 1'b0;
                end
            endcase
        end else begin
            state <= IDLE;
            GCLK <= 1'b0;
        end
    end
endmodule