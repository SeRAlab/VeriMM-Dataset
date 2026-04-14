module rc_oscillator #(parameter COUNT_LIMIT = 10) (
    input wire clk,
    input wire rst,
    output reg out
);
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            out <= 0;
        end else begin
            if (count >= COUNT_LIMIT) begin
                out <= ~out;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule