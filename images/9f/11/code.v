module top_module(
    input clk,
    input en,
    input en_ff,
    input [31:0] data,
    output reg q
);wire gated_clk = clk & en; // create a gated clock signal
    
    always @(posedge gated_clk) begin // use the gated clock for the flip-flop
        if (en_ff) begin // only update the output when enabled
            q <= data;
        end
    end
    
endmodule