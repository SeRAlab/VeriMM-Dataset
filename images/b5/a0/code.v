module up_down_counter (
    input clk,
    input rst_n,
    input en,
    input up_down,
    output reg [2:0] count);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 3'b000;
        end else if (en) begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
endmodule