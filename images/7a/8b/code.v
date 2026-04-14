module sync_updown_counter(
    input clk,
    input rst_n,
    input enable,
    input up_down,
    output reg [7:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 8'b00000000;
        end else if (enable) begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
endmodule