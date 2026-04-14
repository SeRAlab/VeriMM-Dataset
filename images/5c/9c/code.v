module johnson_counter_with_async_reset_6bit(
    input clk,
    input reset,
    output reg [5:0] count
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 6'b000001;
        end else begin
            count <= {count[4:0], ~count[5]};
        end
    end
endmodule