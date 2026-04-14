module top_module(
    input CLK,
    input RESET,
    input [2:0] TEMP,
    input [2:0] THRESHOLD,
    output reg ALARM,
    output reg HOT,
    output reg COLD
);always @(posedge CLK) begin
        if (RESET) begin
            ALARM <= 0;
            HOT <= 0;
            COLD <= 0;
        end else begin
            if (TEMP > THRESHOLD) begin
                HOT <= 1;
                COLD <= 0;
                ALARM <= 1;
            end else if (TEMP < THRESHOLD) begin
                HOT <= 0;
                COLD <= 1;
                ALARM <= 1;
            end else begin
                HOT <= 0;
                COLD <= 0;
                ALARM <= 0;
            end
        end
    end

endmodule