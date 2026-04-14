module top_module(RESET, CLK, ENABLE, COUNT18, COUNT32, RESET_INT, DONE, EN_BCLK);input wire RESET;
input wire CLK;
input wire ENABLE;
input wire COUNT18;
input wire COUNT32;
output reg RESET_INT;
output reg DONE;
output reg EN_BCLK;

localparam E_RESET = 2'b00;
localparam E_ESPERA = 2'b01;
localparam E_LEER = 2'b11;

reg [1:0] NEXT_STATE = E_RESET;
reg [1:0] STATE = E_RESET;

always @(RESET, ENABLE, COUNT18, COUNT32, STATE)
begin
    case (STATE)
        E_RESET:
            if (RESET)
                NEXT_STATE = E_RESET;
            else if (ENABLE)
                NEXT_STATE = E_ESPERA;
            else
                NEXT_STATE = E_RESET;
        E_ESPERA:
            if (COUNT18)
                NEXT_STATE = E_LEER;
            else
                NEXT_STATE = E_ESPERA;
        E_LEER:
            if (COUNT32)
                NEXT_STATE = E_ESPERA;
            else
                NEXT_STATE = E_LEER;
        default:
            NEXT_STATE = E_RESET;
    endcase
end

always @(posedge CLK)
begin
    if (RESET)
        STATE <= E_RESET;
    else
        STATE <= NEXT_STATE;
end

always @(STATE)
begin
    case (STATE)
        E_RESET:
            begin
                DONE <= 1'b0;
                RESET_INT <= 1'b1;
                EN_BCLK <= 1'b0;
            end
        E_ESPERA:
            begin
                DONE <= 1'b0;
                RESET_INT <= 1'b0;
                EN_BCLK <= 1'b1;
            end
        E_LEER:
            begin
                DONE <= 1'b1;
                RESET_INT <= 1'b0;
                EN_BCLK <= 1'b1;
            end
        default:
            begin
                DONE <= 1'b0;
                RESET_INT <= 1'b1;
                EN_BCLK <= 1'b0;
            end
    endcase
end

endmodule