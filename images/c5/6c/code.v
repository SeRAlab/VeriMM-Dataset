module gray_code_counter (
    input clk,
    input reset,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'b000;
        end
        else begin
            count <= count ^ (count >> 1);
        end
    end

endmodule