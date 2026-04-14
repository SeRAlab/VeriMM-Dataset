module synchronizer(
    input clk,
    input reset,
    input async_in,
    output reg sync_out);

    reg sync_stage1;
    
    always @(posedge clk) begin
        if (reset) begin
            sync_stage1 <= 1'b0;
            sync_out <= 1'b0;
        end
        else begin
            sync_stage1 <= async_in;
            sync_out <= sync_stage1;
        end
    end
endmodule