module bidir_counter(
    input clk,
    input rst,
    input up_down,
    output reg [7:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'b00000000;
        end else begin
            if (up_down) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end
endmodule