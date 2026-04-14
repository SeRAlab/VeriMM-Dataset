module top_module(
    input clk,
    input shiftnld,
    input captnupdt,
    output mainclk,
    output updateclk,
    output capture,
    output update
);reg mainclk_tmp;
reg updateclk_tmp;
reg capture_tmp;
reg update_tmp;

always @(*) begin
    case ({captnupdt, shiftnld})
        2'b10, 2'b11 :
            begin
                mainclk_tmp = 1'b0;
                updateclk_tmp = clk;
                capture_tmp = 1'b1;
                update_tmp = 1'b0;
            end
        2'b01 :
            begin
                mainclk_tmp = 1'b0;
                updateclk_tmp = clk;
                capture_tmp = 1'b0;
                update_tmp = 1'b0;
            end
        2'b00 :
            begin
                mainclk_tmp = clk;
                updateclk_tmp = 1'b0;
                capture_tmp = 1'b0;
                update_tmp = 1'b1;
            end
        default :
            begin
                mainclk_tmp = 1'b0;
                updateclk_tmp = 1'b0;
                capture_tmp = 1'b0;
                update_tmp = 1'b0;
            end
    endcase
end

assign mainclk = mainclk_tmp;
assign updateclk = updateclk_tmp;
assign capture = capture_tmp;
assign update = update_tmp;

endmodule