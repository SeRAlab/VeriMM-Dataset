module top_module( clk, reset, d, q );// synthesis attribute keep_hierarchy dffc_13 "true";
    input clk;
    input reset;
    input [12:0] d;
    output [12:0] q;
    reg [12:0] q, q_delayed;
    // synopsys translate_off
`ifdef RANDOM_INIT
    initial
    $random_init("q");
`endif
`ifdef CHK_RESET_EOS
    assert_quiescent_state #(0,1,0, 
    "***ERROR ASSERT: reset still asserted at end of simulation")
    a0(.clk(clk),.reset_n(1'b1), .state_expr(reset),
    .check_value(1'b0), .sample_event(1'b0));
`endif
    // synopsys translate_on
    always @(posedge clk) begin
        if (reset) begin
            q <= 13'b0;
            q_delayed <= 13'b0;
        end
        else begin
            q_delayed <= q;
            q <= d + q_delayed;
        end
    end
endmodule