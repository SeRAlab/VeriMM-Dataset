module top_module(
        input async_sig,
        input clk,
        output rise,
        output fall
    );reg [1:0] resync;

    assign rise = (resync == 2'b01);
    assign fall = (resync == 2'b01);

    always @(posedge clk) begin
        resync <= {resync[0], async_sig};
    end

endmodule