module top_module(
    input CLK,
    input EN,
    input TE,
    input RESET,
    output reg ENCLK
);always @(posedge CLK or negedge RESET) begin
        if (RESET == 0) begin
            ENCLK <= 0;
        end else if (EN == 1 && TE == 0) begin
            ENCLK <= 1;
        end else begin
            ENCLK <= 0;
        end
    end

endmodule