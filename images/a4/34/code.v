module top_module(
    clk,
    shiftnld,
    captnupdt,
    mainclk,
    updateclk,
    capture,
    update
    );// INPUT PORTS
input  clk;
input  shiftnld;
input  captnupdt;
    
// OUTPUTPUT PORTS
output mainclk;
output updateclk;
output capture;
output update;

// INTERNAL VARIABLES
reg mainclk_tmp;
reg updateclk_tmp;
reg capture_tmp;
reg update_tmp;

initial
begin
    mainclk_tmp <= 'b0;
    updateclk_tmp <= 'b0;
    capture_tmp <= 'b0;
    update_tmp <= 'b0;
end

always @(captnupdt or shiftnld or clk)
begin
    case ({captnupdt, shiftnld})
    2'b10, 2'b11 :
        begin
            mainclk_tmp <= 'b0;
            updateclk_tmp <= clk;
            capture_tmp <= 'b1;
            update_tmp <= 'b0;
        end
    2'b01 :
        begin
            mainclk_tmp <= 'b0;
            updateclk_tmp <= clk;
            capture_tmp <= 'b0;
            update_tmp <= 'b0;
        end
    2'b00 :
        begin
            mainclk_tmp <= clk;
            updateclk_tmp <= 'b0;
            capture_tmp <= 'b0;
            update_tmp <= 'b1;
        end
    default :
        begin
            mainclk_tmp <= 'b0;
            updateclk_tmp <= 'b0;
            capture_tmp <= 'b0;
            update_tmp <= 'b0;
        end
    endcase
end

assign mainclk = mainclk_tmp;
assign updateclk = updateclk_tmp;
assign capture = capture_tmp;
assign update = update_tmp;

endmodule