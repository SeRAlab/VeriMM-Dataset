module down_counter (
    input clk,
    input reset,
    output reg [11:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 12'hFFF;
        end else begin
            count <= count - 1;
        end
    end

endmodule