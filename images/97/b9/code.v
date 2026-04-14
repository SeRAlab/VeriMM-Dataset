module top_module (
    input clk,
    input reset,
    input sin,
    output reg [3:0] pout
);
    always @(posedge clk) begin
        if (reset)
            pout <= 4'b0000;
        else
            pout <= {pout[2:0], sin};
    end
endmodule