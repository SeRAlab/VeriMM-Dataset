module sync_module(
    input       clk,
    input       rst_n,
    input       async_in,
    output reg  sync_out
);

    reg sync_1, sync_2;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sync_1 <= 1'b0;
            sync_2 <= 1'b0;
            sync_out <= 1'b0;
        end
        else begin
            sync_1 <= async_in;
            sync_2 <= sync_1;
            sync_out <= sync_2;
        end
    end

endmodule