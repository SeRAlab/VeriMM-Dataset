module verified_dff_async_reset(
    input clk,
    input rst_n,
    input d,
    
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule