module loadable_counter_with_enable_sync_reset_7bit(
    input clk,
    input reset,
    input enable,
    input load,
    input [6:0] load_value,
    output reg [6:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 7'b0000000;
        end else if (load) begin
            count <= load_value;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule