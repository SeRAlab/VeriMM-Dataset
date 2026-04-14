module sync_down_counter_6bit(
    input clk,
    input ld,
    input [5:0] load_val,
    output reg [5:0] q
    );

    always @(posedge clk) begin
        if (ld) begin
            q <= load_val;
        end else begin
            q <= q - 1;
        end
    end
endmodule