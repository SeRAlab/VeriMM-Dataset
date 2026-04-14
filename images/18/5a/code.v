module clock_gated_dff (
    input wire clk,
    input wire enable,
    input wire d,
    output reg q
);
    always @(posedge clk or negedge enable) begin
        if (!enable)
            q <= q; // retain previous value
        else
            q <= d; // update output
    end
endmodule