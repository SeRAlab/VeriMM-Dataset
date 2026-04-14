module binary_counter_async_clear_sync_set (
    input clk,
    input clr_n,
    input set,
    input en,
    output reg [3:0] count);

    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) begin
            count <= 4'b0000;
        end else if (set) begin
            count <= 4'b1111;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule