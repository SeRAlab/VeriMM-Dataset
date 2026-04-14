module up_down_counter (
    input clk,
    input enable,
    input dir,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (enable) begin
            if (dir) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end

endmodule