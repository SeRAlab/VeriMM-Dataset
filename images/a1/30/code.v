module gray_counter(
    input clk,
    input reset,
    output reg [3:0] gray
    );

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
    end

    always @(count) begin
        gray = (count >> 1) ^ count;
    end
endmodule