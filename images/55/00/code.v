module top_module(
    input LOCKED,
    input [31:0] desired_shift_1000,
    input clk,
    input rst,
    output reg fail
);reg [31:0] clk_shifted;
    reg [31:0] clk_period_1000;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fail <= 0;
            clk_shifted <= 0;
            clk_period_1000 <= 0;
        end else if (LOCKED) begin
            clk_period_1000 <= clk / 1000;
            if (desired_shift_1000 > 0) begin
                #(((desired_shift_1000 / 1000.0) * ((clk_period_1000 / 1000.0) / 360.0)) - 0.1);
                clk_shifted <= #0 clk << (desired_shift_1000 / 1000);
                if (clk_shifted !== 0) begin
                    fail <= 1;
                end
            end else if (desired_shift_1000 < 0) begin
                #(((clk_period_1000 / 1000.0) + ((desired_shift_1000 / 1000.0) * ((clk_period_1000 / 1000.0) / 360.0))) - 0.1);
                clk_shifted <= #0 clk << ((clk_period_1000 / 1000) + (desired_shift_1000 / 1000));
                if (clk_shifted !== 0) begin
                    fail <= 1;
                end
            end
            #0.2;
            if (clk_shifted !== 1 && desired_shift_1000 !== 0) begin
                fail <= 1;
            end
        end else begin
            fail <= 0;
        end
    end
endmodule