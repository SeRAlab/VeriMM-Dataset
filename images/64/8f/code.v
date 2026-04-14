module top_module(
    input i_clk,
    input i_rst,
    input i_start,
    input [399:0] i_v_state,
    output [399:0] o_v_state,
    output o_done
    );assign o_v_state = ~i_v_state;
    assign o_done = 1'b0;
    
endmodule