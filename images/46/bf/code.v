module top_module(
    input [6:0] address,
    output reg  bar_led_ce_n,
                board_led_ce_n,
                switch_ce_n,
                mem1_ce_n,
                mem2_ce_n);always @(address) begin
        
        switch_ce_n    = 1'b1;
        bar_led_ce_n   = 1'b1;
        mem2_ce_n      = 1'b1;
        board_led_ce_n = 1'b1;
        mem1_ce_n      = 1'b1;

        casex (address)
            7'h74: switch_ce_n    = 1'b0;
            7'h6C: bar_led_ce_n   = 1'b0;
            7'h5?: mem2_ce_n      = 1'b0;
            7'h2F: board_led_ce_n = 1'b0;
            7'h0?: mem1_ce_n      = 1'b0;
        endcase
    end
endmodule