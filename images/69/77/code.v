module up_down_counter (
    input clk,
    input rst,
    input en,
    input dir,
    output reg [2:0] count);

    always @(posedge clk) begin
        if (rst) begin
            count <= 3'b0;
        end else if (en) begin
            if (dir) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
endmodule