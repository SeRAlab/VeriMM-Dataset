module top_module(
    input CLK,
    input EN,
    input TE,
    input RESET,
    output reg ENCLK
);always @(posedge RESET) begin
        if (RESET) begin
            ENCLK <= 0;
        end else if (!EN) begin
            ENCLK <= 0;
        end else if (TE) begin
            ENCLK <= 1;
        end else begin
            ENCLK <= CLK;
        end
    end

endmodule